import 'dart:async';
import 'dart:io';
import 'package:donghangnhanh/controllers/qr_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QrVideoScreen extends StatefulWidget {
  const QrVideoScreen({Key? key}) : super(key: key);

  @override
  State<QrVideoScreen> createState() => _QrVideoScreenState();
}

class _QrVideoScreenState extends State<QrVideoScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isPaused = false;
  String? _videoPath;
  int _selectedCameraIndex = 0;

  // QR Scanner variables
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  String? _scanResult;
  bool _isQrMode = true; // Start in QR scanning mode
  Timer? _timer;
  int _elapsedSeconds = 0;
  String _selectedOption = "";
  int _remainingSeconds = 600;
  final controller = Get.put(QrVideoController(apiService: Get.find()));


  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController?.pauseCamera();
    } else if (Platform.isIOS) {
      _qrViewController?.resumeCamera();
    }
  }

  // Phương thức để lấy danh sách camera có sẵn
  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _showErrorDialog('Không tìm thấy camera nào trên thiết bị');
        return;
      }
    } catch (e) {
      print("Lỗi khi lấy danh sách camera: $e");
      _showErrorDialog('Lỗi khi truy cập camera: $e');
    }
  }

// Phương thức để khởi tạo camera ban đầu
  Future<void> _initializeCamera() async {
    try {
      await _initCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        await _initCameraController(_cameras![_selectedCameraIndex]);
      }
    } catch (e) {
      _showErrorDialog('Lỗi khởi tạo camera: $e');
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
      enableAudio: false,
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
        _showErrorDialog('Error initializing camera controller: $e');
      }
    }
  }


  // QR code scanner setup
  void _onQRViewCreated(QRViewController controller) {
    _qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _scanResult = scanData.code;
      });

      // Tự động chuyển sang chế độ quay video sau khi quét được mã QR
      _switchToVideoMode();
    });
  }

  // Chuyển sang chế độ quay video và bắt đầu quay
  void _switchToVideoMode() async {
    if (_isQrMode) {
      // Đợi một chút để người dùng có thể thấy kết quả mã QR đã quét
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        try {
          // Ngừng QR scanner trước khi chuyển đổi
          if (_qrViewController != null) {
            try {
              await _qrViewController!.pauseCamera();
              // Thêm thời gian chờ sau khi dừng camera QR
              // await Future.delayed(const Duration(seconds: 1));
            } catch (e) {
              print("Lỗi khi dừng camera QR: $e");
            }
            
            try {
              _qrViewController!.dispose();
              // Thêm thời gian chờ sau khi giải phóng QR controller
              // await Future.delayed(const Duration(seconds: 1));
            } catch (e) {
              print("Lỗi khi giải phóng QR controller: $e");
            }
            _qrViewController = null;
          }
        } catch (e) {
          print("Lỗi khi xử lý QR scanner: $e");
          return; // Thoát nếu có lỗi với QR scanner
        }

        // Giải phóng camera controller hiện tại nếu có
        if (_cameraController != null) {
          try {
            // await _cameraController!.dispose();
            // Thêm thời gian chờ sau khi giải phóng camera controller
            await Future.delayed(const Duration(seconds: 1));
          } catch (e) {
            print("Lỗi khi giải phóng camera controller: $e");
          }
          _cameraController = null;
        }

        setState(() {
          _isQrMode = false;
        });

        try {
          // Khởi tạo lại camera từ đầu
          await Future.delayed(const Duration(seconds: 1)); // Thêm delay trước khi khởi tạo
          await _initCameras();
          if (_cameras != null && _cameras!.isNotEmpty) {
            await Future.delayed(const Duration(seconds: 1)); // Thêm delay trước khi khởi tạo controller
            await _initCameraController(_cameras![_selectedCameraIndex]);
            // Đợi camera khởi tạo hoàn tất
            await Future.delayed(const Duration(seconds: 2));

            if (mounted && _cameraController != null && _cameraController!.value.isInitialized) {
              // Bắt đầu quay video tự động
              if (!_isRecording) {
                await Future.delayed(const Duration(seconds: 1)); // Thêm delay trước khi bắt đầu quay
                _startRecording();
              }
            }
          }
        } catch (e) {
          print("Lỗi khi khởi tạo camera mới: $e");
          _showErrorDialog('Lỗi khi khởi tạo camera. Vui lòng thử lại.');
        }
      }
    }
  }

  // Video recording methods
  Future<void> _startRecording() async {
    if (!_isInitialized || _cameraController == null || !_cameraController!.value.isInitialized) {
      _showErrorDialog('Camera chưa sẵn sàng. Vui lòng thử lại.');
      return;
    }

    try {
      // Đảm bảo camera được mở trước khi quay
      if (!_cameraController!.value.isInitialized) {
        await _cameraController!.initialize().catchError((e) {debugPrint(e);});
      }

      // Tạo thư mục để lưu video
      final Directory appDir = await getTemporaryDirectory();
      final String videoDirectory = '${appDir.path}/Videos';
      await Directory(videoDirectory).create(recursive: true);

      // Tạo tên file với timestamp hiện tại
      final String fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final String filePath = path.join(videoDirectory, fileName);

      // Bắt đầu quay video
      if (_cameraController!.value.isInitialized) {
        await _cameraController!.startVideoRecording();
      }

      if (mounted) {
        setState(() {
          _isRecording = true;
          _isPaused = false;
          _videoPath = filePath;
          _startTimer();
        });
      }
    } catch (e) {
      String errorMessage = 'Lỗi khi bắt đầu quay video: $e';
      print(errorMessage); // In lỗi ra console để dễ debug
      _showErrorDialog(errorMessage);

      // Thử khởi tạo lại camera nếu có lỗi
      if (mounted) {
        _initCameras();
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording || _cameraController == null) {
      return;
    }

    try {
      if (_cameraController!.value.isRecordingVideo) {
        final XFile videoFile = await _cameraController!.stopVideoRecording();
        if (mounted) {
          setState(() {
            _isRecording = false;
            _isPaused = false;
            _videoPath = videoFile.path;
            _stopTimer();
          });

          // Lưu video vào thư viện
          try {
            final File file = File(videoFile.path);
            if (await file.exists()) {
              final result = await ImageGallerySaver.saveFile(file.path);
              if (result['isSuccess']) {
                controller.uploadFile(file, file.path.split('.').last);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video đã được lưu vào thư viện')),
                );
              } else {
                _showErrorDialog('Không thể lưu video vào thư viện');
              }
            }
          } catch (e) {
            print('Error saving video to gallery: $e');
            _showErrorDialog('Lỗi khi lưu video vào thư viện: $e');
          }
        }
      }
    } catch (e) {
      print('Error stopping video recording: $e');
      if (mounted) {
        _showErrorDialog('Error stopping video recording: $e');
      }
    }
  }


  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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


  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    _qrViewController?.dispose();
    _stopTimer();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _cameraController == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quét QR & Quay Video'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isQrMode ? 'Quét mã QR' : 'Quay video'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Camera preview
                if (!_isQrMode)
                  CameraPreview(_cameraController!),

                // QR Scanner
                if (_isQrMode)
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.blue,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),

                // Recording indicator
                if (_isRecording && !_isQrMode)
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
                          Icon(
                            _isPaused ? Icons.pause : Icons.circle,
                            color: Colors.white,
                            size: 12,
                          ),
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
                if (!_isQrMode && _selectedOption.isEmpty)
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
                            title: Text('Đóng hàng'),
                            value: 'package',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() => _selectedOption = value!);
                            },
                          ),
                          RadioListTile(
                            title: Text('Nhập hàng'),
                            value: 'inbound',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() => _selectedOption = value!);
                            },
                          ),
                          RadioListTile(
                            title: Text('Xuất hàng'),
                            value: 'outbound',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() => _selectedOption = value!);
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
                if (_isQrMode)
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
                      icon: Icons.stop,
                      isStart: true,
                      label: 'Dừng',
                      onPressed: _stopRecording,
                    ),
                    // _ControlButton(
                    //   icon: _isPaused ? Icons.play_arrow : Icons.pause,
                    //   label: _isPaused ? 'Tiếp tục' : 'Tạm dừng',
                    //   onPressed: _isPaused ? _resumeRecording : _pauseRecording,
                    // ),
                  ],
              ],
            ),
          ),
        ],
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