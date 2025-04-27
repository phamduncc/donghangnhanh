import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unleash_proxy_client_flutter/unleash_proxy_client_flutter.dart';
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

  final unleash = UnleashClient(
      url: Uri.parse('https://flag.dhn.io.vn/api/frontend'),
      clientKey: '*:production.39f000ce4c6c0f81732d90929fd5ecea778b3de9d21f851dc33c6877',
      appName: 'dohana-app');
  unleash.start();

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