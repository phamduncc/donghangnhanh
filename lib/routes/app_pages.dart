import 'package:donghangnhanh/views/list_parcel_item_screen.dart';
import 'package:donghangnhanh/views/qr_image_screen.dart';
import 'package:donghangnhanh/views/splash_screeen.dart';
import 'package:get/get.dart';
import '../views/home_page.dart';
import '../views/login_view.dart';
import '../bindings/home_binding.dart';
import '../bindings/login_binding.dart';

class AppPages {
  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => SplashView(),
    ),
    GetPage(
      name: '/',
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/qr_image',
      page: () => QrImageScreen(),
    ),
    GetPage(
      name: '/list_parcel_item',
      page: () => ListParcelItemScreen(),
    ),
  ];
}