import 'package:donghangnhanh/model/response/order_parcel_response.dart';
import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParcelController extends GetxController {
  final ApiService apiService;

  ListParcelController({required this.apiService});

  // Danh sách đơn hàng
  final RxList<OrderParcelResponse> parcels = <OrderParcelResponse>[].obs;

  // Trạng thái loading
  final RxBool isLoading = false.obs;

  RxString shippingCompany = 'SPX'.obs;
  RxInt size = 10.obs;
  RxInt page = 0.obs;
  RxInt totalPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadParcels();
  }

  // Hàm load danh sách đơn hàng
  void loadParcels({String? keySearch}) async {
    isLoading.value = true;
    try {
      var result = await apiService.getListParcel(
        page: page.value,
        limit: size.value,
        name: keySearch,
      );
      if (result != null) {
        parcels.assignAll(result);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách đơn hàng');
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm tạo đơn mới
  Future<void> createParcel({
    required String name,
    required String shippingCompany,
  }) async {
    try {
      var result = await apiService.createParcel(
        name: name,
        shippingCompany: shippingCompany,
      );
      if (result != null) {
        Get.snackbar('Thông báo', 'Tạo thành công',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}