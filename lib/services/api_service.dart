
import 'dart:io';

import 'package:donghangnhanh/model/base_api_response.dart';
import 'package:donghangnhanh/model/login_request.dart';
import 'package:donghangnhanh/model/response/login_response.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

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

  Future<dynamic> createParcel({
    required String name,
    required String shippingCompany,
  }) async {
     var body = {
       "name": name,
       "shippingCompany": shippingCompany
     };
    try {
      final response = await _httpManager.post(
        url: URLConstants.CREATE_PARCEL, // Thay bằng URL thật
        data: body,
      );
      var res = BaseApiResponse.fromJson(response);
      if (res.code == 200||res.code == 201) {
        return res;
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi gửi FormData: $e');
    }
  }

  Future<void> createParcelItem({
    required String parcelId,
    required String orderCode,
    required bool isDuplicate,
    required File imageFile,
  }) async {
    // Định dạng thời gian giống đoạn JS của bạn
    final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
    final fileName = '${orderCode}_$formattedDate.png';

    // Tạo FormData
    final formData = dio.FormData.fromMap({
      'parcelId': parcelId,
      'orderCode': orderCode,
      'isDuplicate': isDuplicate.toString(),
      'file': await dio.MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      ),
    });

    try {
      final response = await _httpManager.postFileUpload(
        url: URLConstants.CREATE_PARCEL_ITEM, // Thay bằng URL thật
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        print('Upload thành công!');
        print('Response: ${response.data}');
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi gửi FormData: $e');
    }
  }

}

