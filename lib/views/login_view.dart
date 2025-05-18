import 'package:donghangnhanh/widget/custom_button.dart';
import 'package:donghangnhanh/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = Get.put<LoginController>(LoginController(apiService: Get.find()));

  @override
  void initState() {
    super.initState();

    controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    Future<void> _login() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await controller.login();
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and title
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Dohana',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 48),

                // Email field
                CustomTextField(
                  controller: controller.usernameController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextField(
                  controller: controller.passwordController,
                  labelText: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Forgot password text
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to forgot password screen
                    },
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                CustomButton(
                  text: 'Đăng nhập',
                  isLoading: _isLoading,
                  onPressed: _login,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),

                // Register option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn không có tài khoản?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Uri url = Uri.parse(
                            'https://wms.dohana.vn/register'); // Liên kết bạn muốn mở
                        await launchUrl(url);
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
