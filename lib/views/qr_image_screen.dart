import 'dart:async';
import 'dart:io';
import 'package:donghangnhanh/controllers/qr_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrImageScreen extends StatefulWidget {
  QrImageScreen({Key? key}) : super(key: key);
  final String parcelId = Get.arguments as String;

  @override
  State<QrImageScreen> createState() => _QrImageScreenState();
}

class _QrImageScreenState extends State<QrImageScreen> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  String? orderCode;
  bool _isCapturing = false; // Track if capture is in progress

  // QR Scanner variables
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  String? _scanResult;
  bool _isQrMode = true; // Start in QR scanning mode
  final controller = Get.put(QrImageController(apiService: Get.find()));

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController?.pauseCamera();
    } else if (Platform.isIOS) {
      _qrViewController?.resumeCamera();
    }
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
    // Khởi tạo lại camera từ đầu
    await _initializeCamera();
    setState(() {
      _isQrMode = false;
    });

    await _qrViewController?.stopCamera();
    _qrViewController?.dispose();
    _qrViewController = null;
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
      // Chụp ảnh
      final XFile file = await _cameraController!.takePicture();
      await GallerySaver.saveImage(file.path);
      final File fileImage = File(file.path);
      controller.createParcelItem(
        parcelId: widget.parcelId,
        orderCode: _scanResult ?? '',
        imageFile: fileImage,
      );
      debugPrint('📁 Video saved to gallery');
      Get.back(result: true);
      _cameraController?.dispose();
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
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

  Widget _buildCameraPreview() {
    if (_cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isQrMode ? 'Quét mã QR' : 'Chụp ảnh'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Camera preview
                if (!_isQrMode) _buildCameraPreview(),

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
