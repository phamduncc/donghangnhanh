import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/list_parcel_controller.dart';

class ListParcelScreen extends StatefulWidget {
  const ListParcelScreen({super.key});

  @override
  State<ListParcelScreen> createState() => _ListParcelScreenState();
}

class _ListParcelScreenState extends State<ListParcelScreen> {
  final ListParcelController controller =
      Get.put(ListParcelController(apiService: Get.find()));

  TextEditingController parcelController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    controller.loadParcels();
    _scrollController.addListener(listener);
    super.initState();
  }

  void listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreParcels();
    }
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
              'Phân loại ĐVVC',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Tên phân loại'),
              content: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tên phân loại'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: parcelController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên phân loại ở đây',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Đơn vị vận chuyển*',
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: controller.shippingCompany.value,
                          isExpanded: true,
                          underline: Container(),
                          items: [
                            'SPX',
                            'SPX Hoả tốc',
                            'J&T',
                            'Ninja van',
                            'VNPost',
                            'GHTK',
                            'ViettelPost',
                            'GHN',
                            'Lalamove',
                            'Ahamove',
                            'LEX',
                            'GrapExpress',
                            'BestExpress',
                            'BeShip'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.shippingCompany.value = newValue ?? '';
                          },
                        ),
                      ),
                    ],
                  )),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Đóng'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (parcelController.text.isEmpty) {
                      Get.snackbar('Validate', 'Vui lòng nhập tên phân loại',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    } else {
                      Get.back();
                      await controller.createParcel(
                          name: parcelController.text,
                          shippingCompany:
                              controller.shippingCompany.value ?? '');
                      controller.loadParcels();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Đi đến phân loại',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Nhập tên phân loại...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          Obx(() => Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.parcels.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.parcels.length) {
                            final parcel = controller.parcels[index];
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.local_shipping,
                                          size: 24),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${parcel.name}-${parcel.parcelCode ?? ''}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Đơn vị vận chuyển: ${parcel.shippingCompany}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              'Số đơn: ${parcel.numItems}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              'Ngày tạo: ${parcel.createdAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(parcel.createdAt!) : ''}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('/list_parcel_item',
                                              arguments: parcel.id);
                                        },
                                        child: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        var res = await Get.toNamed('/qr_image',
                                            arguments: parcel.id);
                                        if (res ?? false) {
                                          controller.loadParcels();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      child: const Text(
                                        'Tạo đơn',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ); // Widget hiện tại của bạn
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
              )),
        ],
      ),
    );
  }
}
