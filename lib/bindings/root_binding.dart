import 'package:donghangnhanh/services/api_service.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService());
  }
}