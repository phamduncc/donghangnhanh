import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/root_binding.dart';
import 'comon/data_center.dart';
import 'network/http_manager.dart';
import 'routes/app_pages.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  Get.put(HTTPManager(Dio()));
  Get.put(ApiService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: RootBinding(),
      title: 'Flutter GetX Base',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}