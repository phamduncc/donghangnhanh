import 'dart:math';

import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:donghangnhanh/model/response/store_model.dart';
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
}