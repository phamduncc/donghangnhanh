import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../controllers/qr_video_controller.dart';

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
      enableAudio: true,
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
      _scanQrPeriodically();
    } catch (e) {
      debugPrint('❌ Error initializing camera or starting recording: $e');
    }
  }

  void _scanQrPeriodically() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!_isRecording || !_cameraController!.value.isInitialized) {
        timer.cancel();
        return;
      }

      try {
        final file = await _cameraController!.takePicture();
        final inputImage = InputImage.fromFilePath(file.path);
        final barcodes = await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          final barcode = barcodes.first;
          final code = barcode.rawValue;
          if (code != null) {
            if (_hasDetectedQR) {
              debugPrint('Check endcode');
              if (code.trim() == 'endcode') {
                timer.cancel();
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
    });
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
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo)
      return;

    try {
      String? _videoPath;
      String orderCode = qrVideoController.orderCode.value;
      final file = await _cameraController!.stopVideoRecording();
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
