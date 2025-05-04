import 'package:donghangnhanh/model/response/list_parcel_items_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ListParcelItemController extends GetxController {
  final ApiService apiService;
  ListParcelItemController({required this.apiService});

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isLoadingMore = false.obs;
  int total = 0;
  int currentPage = 0;
  int totalPages = 1;
  RxList<ParcelItem> parcelItems = <ParcelItem>[].obs;
  RxString filePath = ''.obs;
  RxString keySearch = ''.obs;

  // Hàm load danh sách đơn hàng
  Future<void> loadParcelItems({required parcelId}) async {
    currentPage = 0;
    totalPages = 1;
    parcelItems.clear();
    loadMoreParcelItems(parcelId: parcelId);
  }

  void loadMoreParcelItems({required parcelId}) async {
    totalPages = (total/10).floor() + 1;
    if (currentPage < totalPages || isLoadingMore.value) {
      try {
        isLoadingMore.value = true;
        var result = await apiService.getListParcelItems(
          page: currentPage,
          limit: 10,
          parcelId: parcelId,
          orderCode: keySearch.value,
        );
        if (result?.data != null && result!.data.isNotEmpty) {
          parcelItems.addAll(result.data);
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

  Future<void> viewParcelImage(String fileName) async {
    var filePath = await apiService.getUrlImage(fileName: fileName);
    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: Get.width * 0.8,
            maxHeight: Get.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Image.network(
                  filePath ?? '',
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          SizedBox(height: 16),
                          Text('Không thể tải ảnh'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}