import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:io';

class QrImageController extends GetxController {
  final ApiService apiService;

  QrImageController({required this.apiService});

  Future<bool> createParcelItem({
    required String parcelId,
    required String orderCode,
    bool isDuplicate = false,
    required File imageFile,
  }) async {
    try {
      var result = await apiService.createParcelItem(
        parcelId: parcelId,
        orderCode: orderCode,
        imageFile: imageFile,
        isDuplicate: isDuplicate,
      );
      return result;
    } catch (e) {
      Get.snackbar('Error', 'Invalid credentials');
      return false;
    }
  }
}