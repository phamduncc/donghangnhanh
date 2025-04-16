import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:donghangnhanh/controllers/qr_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrImageScreen extends StatefulWidget {
  QrImageScreen({super.key});

  final String parcelId = Get.arguments as String;

  @override
  State<QrImageScreen> createState() => _QrVideoScreenState();
}

class _QrVideoScreenState extends State<QrImageScreen> {
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;
  final controller = Get.put(QrImageController(apiService: Get.find()));
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _hasDetectedQR = false;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  ResolutionPreset _selectedResolution = ResolutionPreset.high;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData(){
    _cameraController = null;
    _isRecording = false;
    _isCameraInitialized = false;
    _hasDetectedQR = false;
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
      ResolutionPreset.high,
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
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_hasDetectedQR ||
          !_isRecording ||
          !_cameraController!.value.isInitialized) {
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
            _hasDetectedQR = true;
            await GallerySaver.saveImage(file.path);
            final File fileImage = File(file.path);
            initData();
            var res = await controller.createParcelItem(
              parcelId: widget.parcelId,
              orderCode: code,
              imageFile: fileImage,
            );
            if (res) {
              Get.snackbar(
                "Thông báo",
                "Tạo đơn thành công",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else {
              _showErrorDialog('Lỗi khi lưu ảnh. Vui lòng thử lại.');
            }
            debugPrint('✅ QR Detected: $code');
          }
        }
      } catch (e) {
        debugPrint('❌ QR scan error: $e');
      }
    });
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
    _cameraController?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2238),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 8),
            const Text('Quay video đơn hàng',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
      body: _cameraController == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_isCameraInitialized)
                  SizedBox.expand(
                      child: CameraPreview(_cameraController!)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.black,
            child: _ControlButton(
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