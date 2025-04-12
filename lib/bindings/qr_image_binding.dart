import 'package:donghangnhanh/controllers/qr_image_controller.dart';
import 'package:get/get.dart';

class QrImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrImageController>(() => QrImageController(apiService: Get.find()));
  }
}