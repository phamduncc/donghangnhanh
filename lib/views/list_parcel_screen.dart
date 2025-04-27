import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2238),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2238),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Danh sách phân loại đơn vị vận chuyển',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add category dialog
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
                  onPressed: () {
                    if (parcelController.text.isEmpty) {
                      Get.snackbar(
                        'Validate',
                        'Vui lòng nhập tên phân loại',
                        backgroundColor: Colors.red,
                        colorText: Colors.white
                      );
                      return;
                    } else {
                      Get.back();
                      controller.createParcel(
                          name: parcelController.text,
                          shippingCompany:
                              controller.shippingCompany.value ?? '');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9B384),
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
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm đơn hàng',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          Obx(() => Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.parcels.length,
                        itemBuilder: (context, index) {
                          final parcel = controller.parcels[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                                    const Icon(Icons.local_shipping, size: 24),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mã đơn: ${parcel['orderNumber']}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Phân loại: ${parcel['category']}',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                            'Đơn vị vận chuyển: ${parcel['carrier']}',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                            'Ngày tạo: ${parcel['createdDate'].toString().split(' ')[0]}',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Xử lý khi nhấn nút tạo đơn
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: const Text(
                                      'Tạo đơn',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              )),
        ],
      ),
    );
  }
}
