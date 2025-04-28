import 'package:get/get.dart';
import 'package:unleash_proxy_client_flutter/unleash_context.dart';
import 'package:unleash_proxy_client_flutter/unleash_proxy_client_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class UnleashController extends GetxController {
  late final UnleashClient unleash;

  // Khởi tạo UnleashClient
  Future<void> initUnleash() async {
    unleash = UnleashClient(
      url: Uri.parse('https://flag.dhn.io.vn/api/frontend'),
      clientKey:
      '*:production.39f000ce4c6c0f81732d90929fd5ecea778b3de9d21f851dc33c6877',
      appName: 'dohana-app',
    );

    await unleash.start();

    // Lấy thông tin phiên bản app
    final PackageInfo info = await PackageInfo.fromPlatform();
    final isAndroid = Platform.isAndroid;

    // Cập nhật context với appVersion và platform
    await unleash.updateContext(
      UnleashContext(
        properties: {
          'appVersion': info.version,
          'platform': isAndroid ? 'android' : 'ios',
        },
      ),
    );
  }

  bool isFeatureEnabled(String featureName) {
    return unleash.isEnabled(featureName);
  }
}
