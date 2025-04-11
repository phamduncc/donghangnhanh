import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/list_parcel_controller.dart';
import '../services/api_service.dart';

class ListParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListParcelController>(() => ListParcelController(apiService: Get.find()));
  }
}