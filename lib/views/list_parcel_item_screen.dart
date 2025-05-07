import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/list_parcel_item_controller.dart';

class ListParcelItemScreen extends StatefulWidget {
  const ListParcelItemScreen({super.key});

  @override
  State<ListParcelItemScreen> createState() => _ListParcelItemScreenState();
}

class _ListParcelItemScreenState extends State<ListParcelItemScreen> {
  final String parcelId = Get.arguments as String;
  final ScrollController _scrollController = ScrollController();
  final controller = Get.put(ListParcelItemController(apiService: Get.find()));
  @override
  void initState() {
    controller.loadParcelItems(parcelId: parcelId);
    _scrollController.addListener(listener);
    super.initState();
  }

  void listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreParcelItems(parcelId:parcelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2238),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Danh sách đơn hàng',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.loadParcelItems(parcelId: parcelId);
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (controller.parcelItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Không có đơn hàng nào'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      controller.loadParcelItems(parcelId: parcelId),
                  child: const Text('Tải lại'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (!mounted) return;
            await controller.loadParcelItems(parcelId: parcelId);
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.parcelItems.length+1,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              if (index < controller.parcelItems.length) {
                final item = controller.parcelItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mã đơn hàng: ${item.orderCode}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.viewParcelImage(item.metadata.filename ?? ''),
                          icon: const Icon(Icons.image),
                          label: const Text('Xem ảnh'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );// Widget hiện tại của bạn
              } else {
                return Obx(() {
                  return controller.isLoadingMore.value
                      ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child: CircularProgressIndicator()),
                  )
                      : const SizedBox.shrink();
                });
              }
            },
          ),
        );
      }),
    );
  }
}
