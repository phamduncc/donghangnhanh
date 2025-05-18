import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/comon/url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../model/base_api_response.dart';

Map<String, dynamic> dioErrorHandle(DioError error) {
  // switch (error.type) {
  //   case DioErrorType.RESPONSE:
  //     return error.response?.data;
  //   case DioErrorType.SEND_TIMEOUT:
  //   case DioErrorType.RECEIVE_TIMEOUT:
  //     return {"success": false, "code": "request_time_out"};
  //
  //   case DioErrorType.DEFAULT:
  //     return {"success": false, "code": "default error"};
  //
  //   default:
      return {"success": false, "code": "connect_to_server_fail"};
  }

class HTTPManager {
  final Dio _dio;

  HTTPManager(this._dio) {
    initApiClient();
  }

  void initApiClient() {
    _dio..options = exportOption(baseOptions);
  }

  void updateToken(String? token) {
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    } else {
      _dio.options.headers.remove("Authorization");
    }
  }

  BaseOptions baseOptions = BaseOptions(
    baseUrl: URLConstants.BASE_URL,
    connectTimeout: const Duration(milliseconds: 100000),
    receiveTimeout: const Duration(milliseconds: 100000),
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  ///Setup Option
  BaseOptions exportOption(BaseOptions options) {
    if (Get.find<StorageService>().getToken() != null) {
      options.headers["Authorization"] =
      "Bearer ${Get.find<StorageService>().getToken()}";
    }
    // UtilLogger.log("headers", options.headers);
    return options;
  }

  Future<dynamic> postFileUpload({required String url, dynamic data, Options? options}) async {
    // UtilLogger.log("[POST URL] ${BASE_URL + url}");
    // UtilLogger.log("[DATA] ${JsonEncoder().convert(data)}");
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );
      // if fail
      if (response.statusCode != 200) {
        return BaseApiResponse(
            code: response.statusCode,
            data: null,
            message: '',
            success: false)
            .toJson();
      }
      // success
      //log("[RESPONSE] ${JsonEncoder().convert(response.data)}");
      return BaseApiResponse(
          code: 200,
          data: response.data,
          message: response.statusMessage,
          success: true)
          .toJson();
    } on DioError catch (error) {
      // if RESULT_EXIRED_TOKEN_401
      if (error.response?.statusCode == 401) {
        print(error);
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'Phiên làm việc của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng !'),
            actions: <Widget>[
              MaterialButton(
                minWidth: 120,
                height: 40,
                onPressed: () async {
                  // await DataCenter.shared().clearAllData();
                  // Get.back();
                  // Get.offAllNamed(Routers.login);
                },
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Xác nhận'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
      return dioErrorHandle(error);
    }
  }

  ///Post method
  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    developer.log("POST URL ${URLConstants.BASE_URL}$url", );
    debugPrint("DATA ${const JsonEncoder().convert(data)}", );
    // UtilLogger.log("DATA", JsonEncoder().convert(data));
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );
      // if fail
      if (response.statusCode != 201) {
        return BaseApiResponse(
            code: response.statusCode,
            data: null,
            message: '',
            success: false)
            .toJson();
      }
      // success
      // UtilLogger.log("POST RESPONSE", const JsonEncoder().convert(response.data));
      return BaseApiResponse(
          code: 201,
          data: response.data,
          message: response.statusMessage,
          success: true)
          .toJson();
    } on DioError catch (error) {
      // if RESULT_EXIRED_TOKEN_401
      if (error.response?.statusCode == 401) {
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'Phiên làm việc của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng !'),
            actions: <Widget>[
              MaterialButton(
                minWidth: 120,
                height: 40,
                onPressed: () async {
                  // await DataCenter.shared().clearAllData();
                  // Get.back();
                  // Get.offAllNamed(Routers.login);
                },
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Xác nhận'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return;
      } else
        return dioErrorHandle(error);
    }
  }

  Future<dynamic> postList({
    required String url,
    List<Map<String, dynamic>>? data,
    Options? options,
  }) async {
    // UtilLogger.log("POST URL", BASE_URL + url);
    // UtilLogger.log("DATA", const JsonEncoder().convert(data));
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );
      // if fail
      if (response.statusCode != 200) {
        return BaseApiResponse(
            code: response.statusCode,
            data: null,
            message: '',
            success: false)
            .toJson();
      }
      // success
      // UtilLogger.log("POST RESPONSE", const JsonEncoder().convert(response.data));
      return BaseApiResponse(
          code: 200,
          data: response.data,
          message: response.statusMessage,
          success: true)
          .toJson();
    } on DioError catch (error) {
      // if RESULT_EXIRED_TOKEN_401
      if (error.response?.statusCode == 401) {
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'Phiên làm việc của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng !'),
            actions: <Widget>[
              MaterialButton(
                minWidth: 120,
                height: 40,
                onPressed: () async {
                  // await DataCenter.shared().clearAllData();
                  // Get.back();
                  // Get.offAllNamed(Routers.login);
                },
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Xác nhận'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return;
      } else
        return dioErrorHandle(error);
    }
  }

  Future<dynamic> postDynamic({
    required String url,
    dynamic data,
    Options? options,
  }) async {
    // UtilLogger.log("POST URL", BASE_URL + url);
    // UtilLogger.log("DATA", const JsonEncoder().convert(data));
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );
      // if fail
      if (response.statusCode != 200) {
        return BaseApiResponse(
            code: response.statusCode,
            data: null,
            message: '',
            success: false)
            .toJson();
      }
      // success
      // UtilLogger.log("POST RESPONSE", const JsonEncoder().convert(response.data));
      return BaseApiResponse(
          code: 200,
          data: response.data,
          message: response.statusMessage,
          success: true)
          .toJson();
    } on DioError catch (error) {
      // if RESULT_EXIRED_TOKEN_401
      if (error.response?.statusCode == 401) {
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'Phiên làm việc của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng !'),
            actions: <Widget>[
              MaterialButton(
                minWidth: 120,
                height: 40,
                onPressed: () async{
                  // await DataCenter.shared().clearAllData();
                  // Get.back();
                  // Get.offAllNamed(Routers.login);
                },
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Xác nhận'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
      return dioErrorHandle(error);
    }
  }

  ///Get method
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    developer.log("GET URL ${URLConstants.BASE_URL}$url", );
    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
        options: options,
      );
      // if fail
      if (response.statusCode != 200) {
        return BaseApiResponse(
            code: response.statusCode,
            data: null,
            message: '',
            success: false)
            .toJson();
      }
      // success
      print(response);
      // UtilLogger.log("GET RESPONSE", const JsonEncoder().convert(response.data));
      return BaseApiResponse(
          code: 200,
          data: response.data,
          message: response.statusMessage,
          success: true)
          .toJson();
    } on DioError catch (error) {
      if (error.response?.statusCode == 401) {
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'Phiên làm việc của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng !'),
            actions: <Widget>[
              MaterialButton(
                minWidth: 120,
                height: 40,
                onPressed: () async{
                  Get.find<StorageService>().clearData();
                  Navigator.pushReplacementNamed(Get.context!, '/login');
                },
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Xác nhận'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
      return dioErrorHandle(error);
    }
  }
}