import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({super.key});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  HomeController controller = Get.put(HomeController(apiService: Get.find()));

  @override
  void initState() {
    controller.getOrder();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2238),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2238),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Row(
          children: [
            Image.asset('assets/images/logo.jpeg', height: 40),
            const SizedBox(width: 8),
            const Text(
              'Dong Hang Nhanh',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard(
                  'Đơn hàng',
                  '1',
                  const Color(0xFF90EE90),
                  Icons.shopping_bag,
                ),
                _buildInfoCard(
                  'Đồng hàng',
                  '1',
                  const Color(0xFFFFD700),
                  Icons.people,
                ),
                _buildInfoCard(
                  'Đã tải lên',
                  '1/1',
                  const Color(0xFF98FB98),
                  Icons.cloud_upload,
                ),
              ],
            ),
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
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách mã vận đơn',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Obx(()=>Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.orderVideoList.length, 
              itemBuilder: (context, index) {
                var order = controller.orderVideoList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SHN-43276582345llllrrrr',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '15/09/2024 14:41:19',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const Row(
                              children: [
                                Text('Video đồng hàng: '),
                                Text(
                                  'Đã xoá',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.close, size: 16, color: Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                );
              },
            ),
          ),),
        ],
      ),

    );
  }

  Widget _buildInfoCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}