import 'package:get/get.dart';
import '../controllers/store_controller.dart';
import '../services/api_service.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreController>(() => StoreController(apiService: Get.find()));
  }
}