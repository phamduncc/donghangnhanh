import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unleash_proxy_client_flutter/unleash_context.dart';
import 'package:unleash_proxy_client_flutter/unleash_proxy_client_flutter.dart';
import 'bindings/root_binding.dart';
import 'comon/data_center.dart';
import 'controllers/unleash_controller.dart';
import 'network/http_manager.dart';
import 'routes/app_pages.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  Get.put(HTTPManager(Dio()));
  Get.put(ApiService());

  // Inject UnleashController vào GetX
  final unleashController = Get.put(UnleashController());

  // Khởi tạo Unleash
  await unleashController.initUnleash();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: RootBinding(),
      title: 'Dohana',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
