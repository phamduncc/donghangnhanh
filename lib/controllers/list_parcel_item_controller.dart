import 'package:donghangnhanh/model/response/list_parcel_items_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ListParcelItemController extends GetxController {
  final ApiService apiService;
  ListParcelItemController({required this.apiService});

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  RxInt size = 10.obs;
  RxInt page = 0.obs;
  RxInt totalPage = 0.obs;
  RxList<ParcelItem> parcelItems = <ParcelItem>[].obs;
  RxString filePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Hàm load danh sách đơn hàng
  Future<void> loadParcelItems({String? keySearch, required parcelId}) async {
    isLoading.value = true;
    try {
      var result = await apiService.getListParcelItems(
        page: page.value,
        limit: size.value,
        parcelId: parcelId,
        orderCode: keySearch,
      );
      if (result != null) {
        parcelItems.assignAll(result);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách đơn hàng');
    } finally {
      isLoading.value = false;
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