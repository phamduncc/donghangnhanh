import 'dart:math';

import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/response/order_stats.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:donghangnhanh/model/response/store_model.dart';
import 'package:donghangnhanh/network/http_manager.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class HomeController extends GetxController {
  final ApiService apiService;

  final stats = Rx<OrderStats?>(null);
  RxList<VideoOrder> orderVideoList = <VideoOrder>[].obs;

  HomeController({required this.apiService});

  void getOrder({String? keySearch}) async {
    try {
      var result = await apiService.getOrderVideo(
        page: 0,
        limit: 1000,
        orderCode: keySearch,
      );
      if (result != null) {
        orderVideoList.assignAll(result);
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  void getOrderStats() async {
    try {
      var result = await apiService.getStatsOrder(period: 'month');
      if (result != null) {
        stats.value = result;
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}
