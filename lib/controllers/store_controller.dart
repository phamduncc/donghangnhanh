import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/response/store_response.dart';
import 'package:donghangnhanh/model/response/store_model.dart';
import 'package:donghangnhanh/network/http_manager.dart';
import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final ApiService apiService;
  final Rx<Store?> activeStore = Rx<Store?>(null);

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
    print('init');
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
        activeStore.value = result.stores!.firstWhereOrNull((e) => e.id == result.activeStore!);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách cửa hàng');
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm chọn cửa hàng
  Future<void> selectStore(String id) async {
    try{
      var result = await apiService.selectStore(
        id,
      );
      if(result != null) {
        await Get.find<StorageService>().saveToken(result.token);
        await Get.find<StorageService>().saveRefreshToken(result.refreshToken);
        Get.find<HTTPManager>().updateToken(result.token);
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}