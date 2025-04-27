import 'package:donghangnhanh/views/qr_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'list_parcel_screen.dart';
import 'qr_image_screen.dart';
import 'home_view.dart';
import 'setting_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeViewScreen(),
    const QrVideoScreen(),
    const ListParcelScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dohana'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: () {
      //         // Show logout confirmation dialog
      //         showDialog(
      //           context: context,
      //           builder: (context) => AlertDialog(
      //             title: const Text('Logout'),
      //             content: const Text('Are you sure you want to logout?'),
      //             actions: [
      //               TextButton(
      //                 onPressed: () => Navigator.pop(context),
      //                 child: const Text('Cancel'),
      //               ),
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                   Navigator.pushReplacementNamed(context, '/login');
      //                 },
      //                 child: const Text('Logout'),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutDashboard, size: 18,),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.video, size: 18,),
            label: 'Ghi hình',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.truck, size: 18,),
            label: 'Vận chuyển',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.settings, size: 18,),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}