import 'dart:io';

import 'package:donghangnhanh/model/base_api_response.dart';
import 'package:donghangnhanh/model/create_order_video_request.dart';
import 'package:donghangnhanh/model/login_request.dart';
import 'package:donghangnhanh/model/response/list_parcel_items_response.dart';
import 'package:donghangnhanh/model/response/login_response.dart';
import 'package:donghangnhanh/model/response/order_parcel_response.dart';
import 'package:donghangnhanh/model/response/order_stats.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:donghangnhanh/model/response/profile_response.dart';
import 'package:donghangnhanh/model/response/storage_response.dart';
import 'package:donghangnhanh/model/response/store_response.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../comon/url.dart';
import '../model/response/list_response_model.dart';
import '../network/http_manager.dart';

class ApiService {
  final _httpManager = Get.find<HTTPManager>();

  Future<LoginResponse?> login(LoginRequest body) async {
    final response =
    await _httpManager.post(url: "/dpm/v1/auth/login", data: body.toJson());
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201) {
      return LoginResponse.fromJson(res.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<LoginResponse?> selectStore(String id) async {
    final response = await _httpManager.post(url: URLConstants.AUTH_STORE(id));
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201) {
      return LoginResponse.fromJson(res.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ProfileResponse> getMe() async {
    final response = await _httpManager.get(
      url: URLConstants.GET_ME,
    );
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return ProfileResponse.fromJson(res.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<StorageResponse> getStorage() async {
    final response = await _httpManager.get(
      url: URLConstants.GET_STORAGE,
    );
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return StorageResponse.fromJson(res.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ListResponse<VideoOrder>?> getOrderVideo(
      {required int page, required int limit, String? orderCode}) async {
    final response = await _httpManager.get(
      url: URLConstants.GET_ORDER_VIDEO(0, 10, orderCode ?? ''),
    );
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      Map<String, dynamic> listJson = res.data;
      var listDataRes =
          ListResponse.fromJson(listJson,
                (json) => VideoOrder.fromJson(json),);
      return listDataRes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ListResponse<OrderParcelResponse>?> getListParcel(
      {required int page, required int limit, String? name}) async {
    final response = await _httpManager.get(
      url: URLConstants.GET_LIST_PARCEL(0, 10, name ?? ''),
    );
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      Map<String, dynamic> listJson = res.data;
      var listDataRes = ListResponse.fromJson(listJson,
            (json) => OrderParcelResponse.fromJson(json),);
      return listDataRes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<StoreResponse?> getListStore() async {
    try {
      final response = await _httpManager.get(
        url: URLConstants.GET_LIST_STORE,
      );
      var res = BaseApiResponse.fromJson(response);
      if (res.code == 201 || res.code == 200) {
        return StoreResponse.fromJson(res.data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ListResponse<ParcelItem>?> getListParcelItems({
    required int page,
    required int limit,
    String? orderCode,
    required parcelId,
  }) async {
    final response = await _httpManager.get(
      url: URLConstants.GET_LIST_PARCEL_ITEM(0, 10, orderCode ?? '', parcelId),
    );
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      Map<String, dynamic> listJson = res.data;
      var listDataRes =
      ListResponse.fromJson(listJson,
            (json) => ParcelItem.fromJson(json),);
      return listDataRes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  initUpload(Map<String, Object> map) async {
    final response =
    await _httpManager.post(url: URLConstants.INIT_UPLOAD, data: map);
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return res.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  completeUpload(Map<String, dynamic> map) async {
    final response =
    await _httpManager.post(url: URLConstants.COMPLETE_UPLOAD, data: map);
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return res.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future presignedUrlFile(Map<String, Object?> map) async {
    final response =
    await _httpManager.post(url: URLConstants.PRE_UPLOAD, data: map);
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
    var body = {"name": name, "shippingCompany": shippingCompany};
    try {
      final response = await _httpManager.post(
        url: URLConstants.CREATE_PARCEL, // Thay bằng URL thật
        data: body,
      );
      var res = BaseApiResponse.fromJson(response);
      if (res.code == 200 || res.code == 201) {
        return res;
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi gửi FormData: $e');
    }
  }

  Future<bool> createParcelItem({
    required String parcelId,
    required String orderCode,
    required bool isDuplicate,
    required File imageFile,
  }) async {
    // Định dạng thời gian giống đoạn JS của bạn
    final formattedDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
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
      var res = BaseApiResponse.fromJson(response);
      if (res.code == 200 || res.code == 201) {
        print('Upload thành công!');
        return true;
      } else {
        print('Lỗi: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gửi FormData: $e');
      return false;
    }
  }

  Future<String?> getUrlImage({
    required String fileName,
  }) async {
    try {
      final response = await _httpManager.get(
        url: URLConstants.GET_FILE_URL(fileName),
      );

      var res = BaseApiResponse.fromJson(response);
      if (res.code == 200 || res.code == 201) {
        return res.data;
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi gửi FormData: $e');
    }
  }

  Future createOrderVideo(CreateOrderVideoRequest body) async {
    final response =
    await _httpManager.post(url: URLConstants.CREATE_ORDER_VIDEO, data: body.toJson());
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return res.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

// getUrlVideo({required String fileName}) async {
//   try {
//     final response = await _httpManager.get(
//       url: URLConstants.GET_FILE_URL(fileName),
//     );
//
//     var res = BaseApiResponse.fromJson(response);
//     if (res.code == 200 || res.code == 201) {
//       return res.data;
//     } else {
//       print('Lỗi: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Lỗi khi gửi FormData: $e');
//   }
// }

  Future<OrderStats?> getStatsOrder(
      {String? period}) async {
    final response = await _httpManager.get(
      url: URLConstants.GET_ORDER_STATS(period ?? 'month'),
    );
    var res = BaseApiResponse.fromJson(response);
    if (res.code == 201 || res.code == 200) {
      return OrderStats.fromJson(res.data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}