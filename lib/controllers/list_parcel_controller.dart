import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParcelController extends GetxController {
  final ApiService apiService;

  ListParcelController({required this.apiService});

  // Danh sách đơn hàng
  final RxList<dynamic> parcels = <dynamic>[].obs;

  // Trạng thái loading
  final RxBool isLoading = false.obs;

  RxString shippingCompany = 'SPX'.obs;

  @override
  void onInit() {
    super.onInit();
    loadParcels();
  }

  // Hàm load danh sách đơn hàng
  void loadParcels() async {
    isLoading.value = true;
    try {
      // TODO: Gọi API lấy danh sách đơn hàng
      await Future.delayed(Duration(seconds: 1)); // Giả lập delay

      // Giả lập dữ liệu mẫu
      parcels.value = List.generate(
          10,
          (index) => {
                'category': 'Hàng điện tử',
                'carrier': 'Giao hàng nhanh',
                'orderNumber': 'DH${100000 + index}',
                'createdDate': DateTime.now().subtract(Duration(days: index)),
              });
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
