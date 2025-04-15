import 'package:donghangnhanh/model/response/store_response.dart';
import 'package:donghangnhanh/model/response/store_model.dart';
import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final ApiService apiService;

  StoreController({required this.apiService});

  // Danh sách cửa hàng
  final RxList<Store> stores = <Store>[].obs;

  // Trạng thái loading
  final RxBool isLoading = false.obs;

  RxInt size = 10.obs;
  RxInt page = 0.obs;
  RxInt totalPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStores();
  }

  // Hàm load danh sách cửa hàng
  void loadStores() async {
    isLoading.value = true;
    try {
      var result = await apiService.getListStore();
      if (result != null && result.stores != null) {
        stores.assignAll(result.stores!);
        // totalPage.value = (result.total ?? 0) ~/ size.value;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách cửa hàng');
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm chọn cửa hàng
  void selectStore(Store store) {
    Get.back(result: store);
  }
}