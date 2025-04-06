import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService apiService;

  HomeController({required this.apiService});

   RxList<OrderVideoResponse> orderVideoList = <OrderVideoResponse>[].obs;

  void getOrder({String? keySearch}) async {
    try{
      var result = await apiService.getOrderVideo(
        page:0,
        limit:10,
        orderCode: keySearch,
      );
      if(result != null) {
        orderVideoList.assignAll(result);
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}