import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/pages/home/page.dart';
import 'package:silent_key/utils/DataManager.dart';
import 'package:silent_key/utils/ThemeManager.dart';
import 'package:silent_key/utils/ToastUtil.dart';

import 'SnakeAnimation.dart';

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

  List<int> passwordList = [-1, -1, -1, -1, -1, -1];
  int _index = 0;

  void _updatePasswordList(int number) {
    setState(() {
      passwordList[_index] = number;
    });
    _index++;

    if (_index == 6) {
      // 等待下一帧渲染完成后执行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLogin();
      });
    }
  }

  void _backspace() {
    if (_index > 0) {
      setState(() {
        passwordList[_index - 1] = -1;
        _index--;
      });
    }
  }

  void _clearPasswordList() {
    setState(() {
      passwordList = [-1, -1, -1, -1, -1, -1];
      _index = 0;
    });
  }

  void _handleLogin() {
    final password = passwordList.join('');
    if (password.isEmpty) {
      return;
    }
    if (password == DataManager.password) {
      Get.off(() => const HomePage());
    } else {
      SpringShakeAnimation.shake(_shakeKey);
      _clearPasswordList();
    }
  }

  final GlobalKey<SpringShakeAnimationState> _shakeKey =
      GlobalKey<SpringShakeAnimationState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const .all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            const Text("Enter App Password", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            SpringShakeAnimation(
              key: _shakeKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  for (int i = 0; i < 6; i++)
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: passwordList[i] >= 0
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FractionallySizedBox(
              widthFactor: 0.8, // 80% 宽度
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            for (int j = 0; j < 3; j++)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(78, 78),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                onPressed: () {
                                  _updatePasswordList(i * 3 + j + 1);
                                },
                                child: Text('${i * 3 + j + 1}'),
                              ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      const SizedBox(width: 78),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(78, 78),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          _updatePasswordList(0);
                        },
                        child: Text('0'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(78, 78),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          _backspace();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
