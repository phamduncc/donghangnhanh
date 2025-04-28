import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/controllers/unleash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final unleashController = Get.find<UnleashController>();

  @override
  void initState() {
    super.initState();
    checkForceUpdate();
  }

  Future<void> checkForceUpdate() async {
    bool shouldForceUpdate =
        unleashController.isFeatureEnabled('app.force_update_app');

    if (shouldForceUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showForceUpdatePopup();
      });
    } else {
      _navigateToNext();
    }
  }

  void showForceUpdatePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cập nhật ứng dụng Dohana'),
          content: const Text(
              'Ứng dụng đã có phiên bản mới. Vui lòng cập nhật để tiếp tục.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cập nhật ngay'),
              onPressed: () {
                // Redirect đến AppStore / PlayStore
                launchUrl(Uri.parse('https://your-appstore-link'));
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    String? token = Get.find<StorageService>().getToken();
    if (token != null && token.isNotEmpty) {
      Get.offNamed('/');
    } else {
      Get.offNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
