import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrImageScreen extends StatefulWidget {
  const QrImageScreen({Key? key}) : super(key: key);

  @override
  State<QrImageScreen> createState() => _QrImageScreenState();
}

class _QrImageScreenState extends State<QrImageScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  String? _imagePath;
  int _selectedCameraIndex = 0;
  bool _isCapturing = false; // Track if capture is in progress

  // QR Scanner variables
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  String? _scanResult;
  bool _isQrMode = true; // Start in QR scanning mode
  String _selectedOption = "";

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
      _switchToCameraMode();
    });
  }

  // Chuyển sang chế độ chụp ảnh
  void _switchToCameraMode() async {
    if (_isQrMode) {
      // Đợi một chút để người dùng có thể thấy kết quả mã QR đã quét
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        try {
          // Ngừng QR scanner trước khi chuyển đổi
          if (_qrViewController != null) {
            try {
              await _qrViewController!.pauseCamera();
            } catch (e) {
              print("Lỗi khi dừng camera QR: $e");
            }
            _qrViewController!.dispose();
            _qrViewController = null;
          }
        } catch (e) {
          print("Lỗi khi xử lý QR scanner: $e");
        }

        setState(() {
          _isQrMode = false;
        });

        // Giải phóng camera controller hiện tại và tạo mới
        if (_cameraController != null) {
          _cameraController = null;
        }

        // Khởi tạo lại camera từ đầu
        await _initCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          await _initCameraController(_cameras![_selectedCameraIndex]);
        }
      }
    }
  }

  // Camera methods
  Future<void> _takePicture() async {
    if (!_isInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      _showErrorDialog('Camera chưa sẵn sàng. Vui lòng thử lại.');
      return;
    }

    if (_isCapturing) {
      _showErrorDialog('Đang xử lý ảnh trước đó. Vui lòng đợi.');
      return;
    }

    try {
      setState(() => _isCapturing = true);

      // Đảm bảo camera được mở trước khi chụp
      if (!_cameraController!.value.isInitialized) {
        await _cameraController!.initialize();
      }

      // Lấy thư mục Pictures của thiết bị
      final Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() // Android
          : await getApplicationDocumentsDirectory(); // iOS

      if (directory == null) {
        throw Exception('Không thể truy cập thư mục lưu trữ');
      }

      final String imageDirectory = Platform.isAndroid
          ? '${directory.path}/Pictures/DongHangNhanh'
          : '${directory.path}/DongHangNhanh';

      // Tạo thư mục nếu chưa tồn tại
      await Directory(imageDirectory).create(recursive: true);

      // Chụp ảnh
      final XFile imageFile = await _cameraController!.takePicture();

      // Lưu ảnh vào thư mục Pictures với tên file duy nhất
      final String fileName =
          'DHN_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(imageDirectory, fileName);
      await imageFile.saveTo(filePath);

// Lưu ảnh vào thư viện
//       await GallerySaver.saveImage(filePath, albumName: 'DongHangNhanh');

      if (mounted) {
        setState(() {
          _imagePath = filePath;
          _isCapturing = false;
        });
        _showErrorDialog('Ảnh đã được lưu vào thư viện: $filePath');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
      String errorMessage = 'Lỗi khi chụp ảnh: $e';
      print(errorMessage);
      _showErrorDialog(errorMessage);

      // Thử khởi tạo lại camera khi có lỗi
      if (mounted) {
        try {
          // await _cameraController?.dispose();
          _cameraController = null;
          await _initializeCamera();
        } catch (reinitError) {
          print('Lỗi khởi tạo lại camera: $reinitError');
        }
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

  @override
  void dispose() {
    if (mounted) {
      if (_cameraController != null) {
        _cameraController!.dispose();
        _cameraController = null;
      }
      if (_qrViewController != null) {
        _qrViewController!.dispose();
        _qrViewController = null;
      }
    }
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
                if (!_isQrMode) CameraPreview(_cameraController!),

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

                // Camera indicator
                if (!_isQrMode)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Chế độ chụp ảnh',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // // QR scan result - chỉ hiển thị trong 1 giây trước khi chuyển sang chế độ quay video
                // if (_isQrMode && _scanResult != null)
                //   Positioned(
                //     bottom: 16,
                //     left: 16,
                //     right: 16,
                //     child: Container(
                //       padding: const EdgeInsets.all(12),
                //       decoration: BoxDecoration(
                //         color: Colors.black.withOpacity(0.7),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           const Text(
                //             'Mã QR đã quét:',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           const SizedBox(height: 4),
                //           Text(
                //             _scanResult!,
                //             style: const TextStyle(
                //               color: Colors.white,
                //             ),
                //             maxLines: 2,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           const SizedBox(height: 8),
                //           const Text(
                //             'Đang chuyển sang chế độ quay video...',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontStyle: FontStyle.italic,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),

                // if (!_isQrMode && _selectedOption.isEmpty)
                //   Positioned(
                //     bottom: 16,
                //     left: 16,
                //     right: 16,
                //     child: Container(
                //       padding: const EdgeInsets.all(12),
                //       decoration: BoxDecoration(
                //         color: Colors.white.withOpacity(0.7),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           RadioListTile(
                //             title: Text('Đóng hàng'),
                //             value: 'package',
                //             groupValue: _selectedOption,
                //             onChanged: (value) {
                //               setState(() => _selectedOption = value!);
                //             },
                //           ),
                //           RadioListTile(
                //             title: Text('Nhập hàng'),
                //             value: 'inbound',
                //             groupValue: _selectedOption,
                //             onChanged: (value) {
                //               setState(() => _selectedOption = value!);
                //             },
                //           ),
                //           RadioListTile(
                //             title: Text('Xuất hàng'),
                //             value: 'outbound',
                //             groupValue: _selectedOption,
                //             onChanged: (value) {
                //               setState(() => _selectedOption = value!);
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
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
                    icon: Icons.camera_alt,
                    isStart: true,
                    label: 'Chụp ảnh',
                    onPressed: _takePicture,
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
