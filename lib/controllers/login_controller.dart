import 'package:credentials_manager/credentials_manager.dart';
import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/login_request.dart';
import 'package:donghangnhanh/network/http_manager.dart';
import 'package:donghangnhanh/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final ApiService apiService;

  LoginController({required this.apiService});

  final TextEditingController usernameController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text:"");

  Future<void> loadData() async {
    try {
      CredentialModel? user = await Get.find<StorageService>().getLoginData();
      if (user != null) {
        usernameController.text = user!.loginOrEmail;
        passwordController.text = user!.password;
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

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
        Get.find<HTTPManager>().updateToken(result.token);

        final credentialModel = CredentialModel(
          id: usernameController.text, // REQUIRED
          loginOrEmail: usernameController.text, // REQUIRED
          password: passwordController.text, // REQUIRED
        );

        /// Saving credential.
        await Get.find<StorageService>().saveLoginData(credentialModel);

        Get.offNamed('/');
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}
