import 'package:donghangnhanh/controllers/store_controller.dart';
import 'package:donghangnhanh/model/response/store_model.dart';
import 'package:donghangnhanh/widget/video_status_badge.dart';
import 'package:donghangnhanh/widget/video_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/home_controller.dart';

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({super.key});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  HomeController controller = Get.put(HomeController(apiService: Get.find()));
  StoreController storeController =
      Get.put(StoreController(apiService: Get.find()));
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    controller.getOrder();
    controller.getOrderStats();
    _scrollController.addListener(listener);
    super.initState();
  }

  void listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreOrders();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    controller.getOrder();
    controller.getOrderStats();
  }

  void _onLoading() async {
    controller.loadMoreOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF1A2238),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2238),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text(
              'Dohana',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Trong ngày',
                    (controller.stats.value?.totalInDay ?? 0).toString(),
                    const Color(0x00000000),
                    LucideIcons.package,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoCard(
                    'Đóng hàng',
                    (controller.stats.value?.totalPacking ?? 0).toString(),
                    const Color(0xFFFFD888),
                    LucideIcons.package,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoCard(
                    'Nhập hàng',
                    (controller.stats.value?.totalInbound ?? 0).toString(),
                    const Color(0xFFB4E0D7),
                    LucideIcons.uploadCloud,
                  ),
                ),
              ],
            ),
          ),
          // Nút chọn cửa hàng
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Obx(() => OutlinedButton(
                  onPressed: () async {
                    final result = await Get.toNamed('/store');
                    if (result != null && result is Store) {
                      storeController.selectStore(result.id);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Bo tròn các góc của nút
                    ),
                    side: const BorderSide(color: Color(0xFFE14D16)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(Icons.store, color: Color(0xFF1A2238)),
                      const SizedBox(width: 8),
                      Text(
                        storeController.activeStore.value?.name ??
                            'Chọn cửa hàng',
                        // style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm mã vận đơn',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                ),
                onChanged: (String val){
                  controller.keySearch.value = val;
                  controller.getOrder();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách mã vận đơn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    LucideIcons.refreshCcw,
                    size: 18,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Obx(
            () => Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.orderVideoList.length + 1,
                itemBuilder: (context, index) {
                  if (index < controller.orderVideoList.length) {
                    var order = controller.orderVideoList[index];
                    return InkWell(
                      onTap: () {
                        Get.offNamed('/video_detail', arguments: {
                          "videoId": order.metadata.filename,
                          "orderType": order.type,
                          "orderCode": order.orderCode,
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.listVideo, size: 24),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order.orderCode,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      VideoStatusBadge(status: order.status)
                                    ],
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(order.createdAt),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  VideoTypeBadge(type: order.type),
                                ],
                              ),
                            ),
                            // const Icon(LucideIcons.badgeCheck,
                            //     color: Colors.green),
                          ],
                        ),
                      ),
                    ); // Widget hiện tại của bạn
                  } else {
                    return Obx(() {
                      return controller.isLoadingMore.value
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE14D16), // hoặc màu bất kỳ
          width: 1,            // độ dày viền
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 4),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
