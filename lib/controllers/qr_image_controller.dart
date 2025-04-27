import 'dart:math';

import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // Cho MIME
import 'package:path/path.dart' as p;
import 'dart:developer' as developer;

class QrImageController extends GetxController {
  final ApiService apiService;

  QrImageController({required this.apiService});

  RxList<OrderVideoResponse> orderVideoLiast = <OrderVideoResponse>[].obs;

  void createParcelItem({
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
      // if(result != null) {
      //   orderVideoList.assignAll(result);
      // }
    } catch (e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}
