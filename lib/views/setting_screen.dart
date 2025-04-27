import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../comon/data_center.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dohana'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'diep tran',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'diep.tv1999@gmail.com',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // TODO: Implement logout logic here
                              Get.find<StorageService>().clearData();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Free Package Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gói miễn phí',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Hết hạn',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildVideoTypeItem(
                  'Video đóng hàng',
                  '0 video / 600 video/tháng',
                ),
                const SizedBox(height: 12),
                _buildVideoTypeItem(
                  'Video đơn vị vận chuyển',
                  '0 video / 600 video/tháng',
                ),
                const SizedBox(height: 12),
                _buildVideoTypeItem(
                  'Video trả hàng',
                  '0 video / 600 video/tháng',
                ),
              ],
            ),
          ),

          // Menu Items
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Hướng dẫn sử dụng',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Tài khoản của tôi',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: LucideIcons.gem,
            title: 'Gói giá tham khảo',
            onTap: () async {
              Uri url = Uri.parse(
                  'https://donghangnhanh.vn/vi#pricing'); // Liên kết bạn muốn mở
              await launchUrl(url);
            },
          ),
          _buildMenuItem(
            icon: Icons.history,
            title: 'Lịch sử cập nhật',
            onTap: () {},
          ),

          const Divider(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildVideoTypeItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}