import 'package:donghangnhanh/model/response/order_parcel_response.dart';
import 'package:donghangnhanh/model/response/profile_response.dart';
import 'package:donghangnhanh/model/response/storage_response.dart';
import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ApiService apiService;

  ProfileController({required this.apiService});

  // Profile người dùng
  final profile = Rx<ProfileResponse?>(null);
  final storage = Rx<StorageResponse?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  // Hàm load danh sách đơn hàng
  void init() async {
    initStorage();
    try {
      var result = await apiService.getMe();
      if (result != null) {
        profile.value = result;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lấy thông tin người dùng');
    }
  }

  void initStorage() async {
    try {
      var result = await apiService.getStorage();
      if (result != null) {
        storage.value = result;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lấy thông tin người dùng');
    }
  }
}
