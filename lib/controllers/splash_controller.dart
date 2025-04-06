import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../comon/data_center.dart';

class SplashController extends GetxController {
  bool hasLogin() {
    final user = StorageService().getUsername();
    return !(user == null);
  }
}