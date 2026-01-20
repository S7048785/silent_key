import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/services/auth_service.dart';
import 'package:silent_key/pages/home/page.dart';
import 'package:silent_key/utils/ToastUtil.dart';
import 'SnakeAnimation.dart';
import 'keyboard_listener.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  List<int> passwordList = [-1, -1, -1, -1, -1, -1];
  int _index = 0;
  bool _isSetupMode = false;
  String? _firstPassword;

  final GlobalKey<SpringShakeAnimationState> _shakeKey =
      GlobalKey<SpringShakeAnimationState>();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await authService.init();

    if (!authService.hasMasterPassword()) {
      // 首次使用，进入设置模式
      setState(() {
        _isSetupMode = true;
      });
    }
  }

  void _updatePasswordList(int number) {
    setState(() {
      passwordList[_index] = number;
      _index++;
    });

    if (_index == 6) {
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
    if (password.isEmpty) return;

    if (_isSetupMode) {
      // 设置模式
      if (_firstPassword == null) {
        // 第一次输入
        if (password.length < 4) {
          ToastUtil.showText(text: 'Password must be at least 4 digits');
          _clearPasswordList();
          return;
        }
        setState(() {
          _firstPassword = password;
        });
        ToastUtil.showText(text: 'Please enter password again');
        _clearPasswordList();
      } else {
        // 第二次输入确认
        if (password == _firstPassword) {
          _savePassword(password);
        } else {
          ToastUtil.showText(text: 'Passwords do not match');
          _clearPasswordList();
          setState(() {
            _firstPassword = null;
          });
        }
      }
    } else {
      // 登录模式
      if (authService.login(password)) {
        ToastUtil.showText(text: 'Welcome back!');
        Get.offAll(() => const HomePage());
      } else {
        SpringShakeAnimation.shake(_shakeKey);
        _clearPasswordList();
      }
    }
  }

  Future<void> _savePassword(String password) async {
    final success = await authService.setMasterPassword(password);
    if (success) {
       ToastUtil.showText(text: 'Password set successfully');
      setState(() {
        _isSetupMode = false;
        _firstPassword = null;
      });
      Get.offAll(() => const HomePage());
    } else {
      ToastUtil.showText(text: 'Failed to set password');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Text(
                  _isSetupMode ? "Set Master Password" : "Enter App Password",
                  style: const TextStyle(fontSize: 24),
                ),
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
                  widthFactor: 0.8,
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
                            child: const Text('0'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(78, 78),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: _backspace,
                            child: const Text(
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
        ),
        LoginKeyboardListener(
          onNumberInput: _updatePasswordList,
          onBackspace: _backspace,
        ),
      ],
    );
  }
}
