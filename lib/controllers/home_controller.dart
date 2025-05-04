import 'package:donghangnhanh/model/response/order_stats.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService apiService;

  final stats = Rx<OrderStats?>(null);
  RxList<VideoOrder> orderVideoList = <VideoOrder>[].obs;
  final RxBool isLoadingMore = false.obs;
  RxString keySearch = ''.obs;

  HomeController({required this.apiService});
  int total = 0;
  int currentPage = 0;
  int totalPages = 1;

  void loadMoreOrders() async {
    totalPages = (total/10).floor() + 1;
    if (currentPage < totalPages || isLoadingMore.value) {
      try {
        isLoadingMore.value = true;
        var result = await apiService.getOrderVideo(
          page: currentPage,
          limit: 10,
          orderCode: keySearch.value,
        );
        if (result?.data != null && result!.data.isNotEmpty) {
          orderVideoList.addAll(result.data);
          total = result.total;
          currentPage++;
        } else {
          totalPages = currentPage; // No more pages
        }
        isLoadingMore.value = false;
      } catch (e) {
        Get.snackbar('Error', 'Invalid credentials');
        isLoadingMore.value = false;
      }
    }
  }

  void getOrder() async {
    currentPage = 0;
    totalPages = 1;
    orderVideoList.clear();
    loadMoreOrders();
  }

  void getOrderStats() async {
    try {
      var result = await apiService.getStatsOrder(period: 'month');
      if (result != null) {
        stats.value = result;
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}
