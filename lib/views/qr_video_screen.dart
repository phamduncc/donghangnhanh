import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../controllers/qr_video_controller.dart';

final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

class QrVideoScreen extends StatefulWidget {
  const QrVideoScreen({super.key});

  @override
  State<QrVideoScreen> createState() => _QrVideoScreenState();
}

class _QrVideoScreenState extends State<QrVideoScreen> {
  final player = AudioPlayer();
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;
  int _remainingSeconds = 0;
  int maxRemainingSeconds = 600;
  Timer? _timer;
  final qrVideoController = Get.put(QrVideoController(apiService: Get.find()));
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _hasDetectedQR = false;
  bool _showZoomSlider = false;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _cameraController = null;
    _isRecording = false;
    _isCameraInitialized = false;
    _remainingSeconds = 0;
    _hasDetectedQR = false;
    _showZoomSlider = false;
    qrVideoController.orderCode.value = '';
    _initializeCameraAndStart();
  }

  Future<void> _initializeCameraAndStart() async {
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      rearCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController!.initialize();
      await _cameraController?.setFlashMode(FlashMode.off);
      _minZoom = await _cameraController!.getMinZoomLevel();
      _maxZoom = await _cameraController!.getMaxZoomLevel();
      _currentZoom = _minZoom;
      await _cameraController!.setZoomLevel(_currentZoom);

      setState(() {
        _isRecording = true;
        _isCameraInitialized = true;
      });
      _cameraController!.startImageStream(_scanQrPeriodically);
    } catch (e) {
      debugPrint('❌ Error initializing camera or starting recording: $e');
    }
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    debugPrint(rotation.toString());
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        throw Exception("Không hỗ trợ rotation: $rotation");
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final sensorOrientation = _cameraController!.description.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
      _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (_cameraController!.description.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  void _scanQrPeriodically(CameraImage img) async {
    if (img == null || img.planes.isEmpty) return;
    // Skip frame để giảm tải
    _frameCount++;
    if (_frameCount % 5 != 0) return;
    if (!_isRecording || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      // final WriteBuffer allBytes = WriteBuffer();
      // for (final Plane plane in img.planes) {
      //   allBytes.putUint8List(plane.bytes);
      // }
      // final bytes = allBytes.done().buffer.asUint8List();
      // debugPrint((InputImageFormatValue.fromRawValue(img.format.raw) ?? InputImageFormat.nv21).name);
      //
      // if (bytes.isEmpty) {
      //   print('Ảnh không có dữ liệu hoặc không hợp lệ!');
      //   return;
      // }
      final inputImage = _inputImageFromCameraImage(img);
      if (inputImage == null) {
        debugPrint('Khong co anh');
        return;
      }
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first;
        final code = barcode.rawValue;
        if (code != null) {
          if (_hasDetectedQR) {
            debugPrint('Check endcode');
            if (code.trim() == 'endcode') {
              _stopRecording();
            }
          } else {
            // start record
            await player.play(AssetSource('sound/start.mp3'));
            _hasDetectedQR = true;
            _startTimer();
            await _cameraController!.startVideoRecording();
            debugPrint('✅ QR Detected: $code');
            qrVideoController.orderCode.value = code;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ QR scan error: $e');
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isRecording) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_remainingSeconds < maxRemainingSeconds) {
          _remainingSeconds++;
        } else {
          timer.cancel();
          _stopRecording();
        }
      });
    });
  }

  Future<void> _stopRecording() async {
    player.play(AssetSource('sound/end.mp3'));
    int duration = _remainingSeconds;
    _remainingSeconds = 0;
    _hasDetectedQR = false;
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo)
      return;

    try {
      String? _videoPath;
      String orderCode = qrVideoController.orderCode.value;
      final file = await _cameraController!.stopVideoRecording();
      print(file.path);
      setState(() {
        _isRecording = false;
        _videoPath = file.path;
      });

      debugPrint('✅ Video saved at: $_videoPath');

      if (_videoPath != null) {
        // qrVideoController.isLoading.value = true;
        initData();

        final uploadedFile = File(_videoPath!);
        final res = await qrVideoController.uploadFile(
            uploadedFile, _videoPath!.split('.').last);

        if (res != null) {
          await qrVideoController.createOrder(res, orderCode, duration);
        } else {
          Get.snackbar('Lỗi', 'Tải video thất bại',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      debugPrint('❌ Stop recording error: $e');
    }
  }

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    _barcodeScanner.close();
    super.dispose();
  }

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Chọn loại quay'),
          children: [
            RadioListTile(
              title: const Text('Đóng hàng'),
              value: 'package',
              groupValue: qrVideoController.selectedOption.value,
              onChanged: (value) {
                qrVideoController.selectedOption.value = value ?? '';
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Nhập hàng'),
              value: 'inbound',
              groupValue: qrVideoController.selectedOption.value,
              onChanged: (value) {
                qrVideoController.selectedOption.value = value ?? '';
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Xuất hàng'),
              value: 'outbound',
              groupValue: qrVideoController.selectedOption.value,
              onChanged: (value) {
                qrVideoController.selectedOption.value = value ?? '';
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2238),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text('Quay video đơn hàng',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
      body: Obx(() {
        return qrVideoController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (_isCameraInitialized)
                          SizedBox.expand(
                              child: CameraPreview(_cameraController!)),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            onPressed: () => _showActionDialog(context),
                            icon: const Icon(
                              LucideIcons.list,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  qrVideoController.orderCode.isNotEmpty
                                      ? '🎥 Đang quay video... $formattedTime'
                                      : '🔍 Đang quét mã QR...',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Mã đơn hàng: ${qrVideoController.orderCode.value}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Nút zoom góc trên bên phải
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.zoom_in,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _showZoomSlider = !_showZoomSlider;
                                  });
                                },
                              ),
                              if (_showZoomSlider)
                                RotatedBox(
                                  quarterTurns: 1,
                                  // Quay slider 90 độ để hiển thị dọc
                                  child: Slider(
                                    value: _currentZoom,
                                    min: _minZoom,
                                    max: _maxZoom,
                                    divisions: (_maxZoom - _minZoom).round(),
                                    label:
                                        '${_currentZoom.toStringAsFixed(1)}x',
                                    onChanged: (value) async {
                                      setState(() => _currentZoom = value);
                                      await _cameraController
                                          ?.setZoomLevel(value);
                                    },
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white30,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (qrVideoController.orderCode.value.isNotEmpty)
                          _ControlButton(
                            icon:
                                _isRecording ? Icons.stop : Icons.mode_standby,
                            isStart: true,
                            label: 'Dừng',
                            onPressed: _stopRecording,
                          )
                        else ...[
                          _ControlButton(
                            icon: Icons.flash_on,
                            label: 'Đèn flash',
                            onPressed: () async {
                              try {
                                if (_cameraController != null) {
                                  await _cameraController
                                      ?.setFlashMode(FlashMode.torch);
                                }
                              } catch (e) {
                                print("Lỗi khi bật/tắt đèn flash: $e");
                              }
                            },
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              );
      }),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isStart;

  const _ControlButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isStart = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: isStart ? Colors.red : Colors.white,
          ),
          child: Icon(
            icon,
            color: isStart ? Colors.white : Colors.black,
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
