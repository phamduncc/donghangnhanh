import 'dart:math';

import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:donghangnhanh/model/response/store_model.dart';
import 'package:donghangnhanh/network/http_manager.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class HomeController extends GetxController {
  final ApiService apiService;

  HomeController({required this.apiService});

   RxList<VideoOrder> orderVideoList = <VideoOrder>[].obs;
  Rxn<Store> selectedStore = Rxn<Store>();

  void getOrder({String? keySearch}) async {
    try{
      var result = await apiService.getOrderVideo(
        page:0,
        limit:1000,
        orderCode: keySearch,
      );
      if(result != null) {
        orderVideoList.assignAll(result);
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  Future<void> selectStore(String id) async {
    try{
      var result = await apiService.selectStore(
        id,
      );
      if(result != null) {
        await Get.find<StorageService>().saveToken(result.token);
        await Get.find<StorageService>().saveRefreshToken(result.refreshToken);
        Get.find<HTTPManager>().updateToken(result.token);
        getOrder();
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}