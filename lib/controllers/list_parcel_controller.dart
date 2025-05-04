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
  final RxBool isLoadingMore = false.obs;
  RxString shippingCompany = 'SPX'.obs;
  int total = 0;
  int currentPage = 0;
  int totalPages = 1;
  RxString keySearch = ''.obs;

  // Hàm load danh sách đơn hàng
  void loadParcels() async {
    currentPage = 0;
    totalPages = 1;
    parcels.clear();
    loadMoreParcels();
  }

  void loadMoreParcels() async {
    totalPages = (total/10).floor() + 1;
    if (currentPage < totalPages || isLoadingMore.value) {
      try {
        isLoadingMore.value = true;
        var result = await apiService.getListParcel(
          page: currentPage,
          limit: 10,
          name: keySearch.value,
        );
        if (result?.data != null && result!.data.isNotEmpty) {
          parcels.addAll(result.data);
          total = result.total;
          currentPage++;
        } else {
          totalPages = currentPage; // No more pages
        }
        isLoadingMore.value = false;
      } catch (e) {
        Get.snackbar('Error', 'Invalid credentials');
        isLoadingMore.value = false;
      }
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