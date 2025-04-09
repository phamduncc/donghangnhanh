
import 'package:donghangnhanh/model/base_api_response.dart';
import 'package:donghangnhanh/model/login_request.dart';
import 'package:donghangnhanh/model/response/login_response.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';

import '../comon/url.dart';
import '../network/http_manager.dart';

class ApiService {
  final _httpManager = Get.find<HTTPManager>();
   Future<LoginResponse?> login(LoginRequest body) async {
    final response = await _httpManager.post(url: "/dpm/v1/auth/login", data: body.toJson());
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201) {
      return LoginResponse.fromJson(res.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<OrderVideoResponse>?> getOrderVideo({required int page,required int limit, String? orderCode}) async {
    final response = await _httpManager.get(url: URLConstants.GET_ORDER_VIDEO(0, 10, ''),);
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
     Map<String, dynamic> listJson = res.data;
      List<OrderVideoResponse> listData = ListVideoOrderResponse.fromJson(res.data).data ?? [];
      return listData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  initUpload(Map<String, Object> map) {}

  completeUpload(Map<String, dynamic> map) {}

  presignedUrlFile(Map<String, Object?> map) async {
    final response = await _httpManager.post(url: URLConstants.PRE_UPLOAD, data: map);
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return res.data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

