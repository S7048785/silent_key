import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/pages/home/page.dart';
import 'package:silent_key/utils/DataManager.dart';
import 'package:silent_key/utils/ThemeManager.dart';
import 'package:silent_key/utils/ToastUtil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// 密码可见性控制，默认为隐藏(true)
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _login() {
    final password = _passwordController.text.trim();
    print(password);
    if (password.isEmpty) {
      ToastUtil.showText('请输入密码', context: context);
      return;
    }
    if (password == DataManager.password) {
      Get.off(() => const HomePage());
    } else {
      ToastUtil.showText('密码错误', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const .all(16),
        child: Column(
          children: [
            const Text("登录", style: TextStyle(fontSize: 64)),
            const Text("登录已有账号", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              autofocus: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                label: const Text('输入密码'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('登录'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('没有账号？', style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    ThemeManager.toggleTheme();
                  },
                  child: const Text('去注册', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
