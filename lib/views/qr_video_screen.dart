import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/qr_video_controller.dart';

class QrVideoScreen extends StatefulWidget {
  const QrVideoScreen({super.key});

  @override
  State<QrVideoScreen> createState() => _QrVideoScreenState();
}

class _QrVideoScreenState extends State<QrVideoScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool isPaused = false;
  bool _isInQRMode = true;
  String? _videoPath;
  int _remainingSeconds = 600;
  bool _isInitialized = false;
  Timer? _timer;
  final qrVideoController = Get.put(QrVideoController(apiService: Get.find()));

  @override
  void initState() {
    _isInitialized = true;
    // _startVideoMode();
    super.initState();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

// Phương thức để khởi tạo camera ban đầu
  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    try {
      if (cameras.isNotEmpty) {
        await _initCameraController(cameras[0]);
      }
    } catch (e) {
      debugPrint('Lỗi khởi tạo camera: $e');
    }
  }

  Future<void> _initCameraController(CameraDescription camera) async {
    if (_cameraController != null) {
      // await _cameraController!.dispose();
      _cameraController = null;
    }

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Error initializing camera controller: $e');
      }
    }
  }

  void _disposeControllers() async {
    await _qrViewController?.stopCamera();
    _qrViewController?.dispose();
    _qrViewController = null;

    await _cameraController?.dispose();
    _cameraController = null;
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    _qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      debugPrint('QR Code scanned: ${scanData.code}');
      qrVideoController.orderCode.value = scanData.code ?? '';
      if (!_isInQRMode) return;
      await _initializeCamera();
      setState(() => _isInQRMode = false);
      await _startVideoMode();
    });
  }

  Future<void> _startVideoMode() async {
    await _qrViewController?.stopCamera();
    _qrViewController?.dispose();
    _qrViewController = null;
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      setState(() => _isCameraInitialized = true);
      _startTimer();
      await _cameraController!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint('❌ Camera error: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo)
      return;

    try {
      final file = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoPath = file.path;
      });

      debugPrint('✅ Video recorded to: $_videoPath');

      if (_videoPath != null) {
        qrVideoController.isLoading.value = true;
        await GallerySaver.saveVideo(_videoPath!);
        final File fileVideo = File(file.path);
        var res = await qrVideoController.uploadFile(
            fileVideo, file.path.split('.').last);
        if (res != null) {
          await qrVideoController.createOrder(res);
          qrVideoController.isLoading.value = false;
        } else {
          qrVideoController.isLoading.value = false;
          Get.snackbar(
            'Error',
            'Lỗi trong quá trình tải file',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        debugPrint('📁 Video saved to gallery');
        // _cameraController?.dispose();
      }
    } catch (e) {
      debugPrint('❌ Stop recording error: $e');
    }
  }

  Widget _buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!);
  }

  void _startTimer() {
    _stopTimer(); // Dừng timer cũ nếu có
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecording) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _stopTimer();
            _stopRecording(); // Hàm dừng quay video
          }
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _remainingSeconds = 600; // Reset về 10 phút
  }

  String get formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isInQRMode ? 'Quét mã QR' : 'Quay video'),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: (qrVideoController.isLoading.value)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: [
                        // QR Scanner
                        if (_isInQRMode) _buildQRView(context),
                        // Camera preview
                        if (!_isInQRMode) _buildCameraPreview(),
                        // Recording indicator
                        if (_isRecording && !_isInQRMode)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (!_isInQRMode &&
                            qrVideoController.selectedOption.isEmpty)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('Đóng hàng'),
                                    value: 'package',
                                    groupValue:
                                        qrVideoController.selectedOption.value,
                                    onChanged: (value) {
                                      setState(() => qrVideoController
                                          .selectedOption.value = value ?? '');
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('Nhập hàng'),
                                    value: 'inbound',
                                    groupValue:
                                        qrVideoController.selectedOption.value,
                                    onChanged: (value) {
                                      setState(() => qrVideoController
                                          .selectedOption.value = value ?? '');
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('Xuất hàng'),
                                    value: 'outbound',
                                    groupValue:
                                        qrVideoController.selectedOption.value,
                                    onChanged: (value) {
                                      setState(() => qrVideoController
                                          .selectedOption.value = value ?? '');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),

            // Control buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_isInQRMode)
                    // In QR mode, add a button to toggle flash
                    _ControlButton(
                      icon: Icons.flash_on,
                      label: 'Đèn flash',
                      onPressed: () {
                        try {
                          if (_qrViewController != null) {
                            _qrViewController!.toggleFlash();
                          }
                        } catch (e) {
                          print("Lỗi khi bật/tắt đèn flash: $e");
                        }
                      },
                    )
                  // else if (!_isRecording)
                  // // In video mode but not recording, show start recording button
                  //   _ControlButton(
                  //     icon: Icons.videocam,
                  //     label: 'Bắt đầu',
                  //     onPressed: _startRecording,
                  //     isStart: true,
                  //   )
                  else ...[
                    // In video mode and recording, show recording controls
                    _ControlButton(
                      icon: _isRecording ? Icons.stop : Icons.mode_standby,
                      isStart: true,
                      label: 'Dừng',
                      onPressed: _stopRecording,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
