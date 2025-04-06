import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/login_request.dart';
import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final ApiService apiService;

  LoginController({required this.apiService});

  final TextEditingController usernameController = TextEditingController(text: "phamdu180199@gmail.com");
  final TextEditingController passwordController = TextEditingController(text:"Cntt@123456");

  Future<void> login() async {
    try{
      var result = await apiService.login(
        LoginRequest(
          password: passwordController.text,
          email: usernameController.text,
        ),
      );
      if(result != null) {
        await Get.find<StorageService>().saveToken(result.token);
        await Get.find<StorageService>().saveRefreshToken(result.refreshToken);
        await Get.find<StorageService>().saveUsername(usernameController.text);
        Get.offNamed('/');
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}
