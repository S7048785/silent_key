import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/services/auth_service.dart';
import 'package:silent_key/utils/ToastUtil.dart';
import 'package:silent_key/pages/home/page.dart';

class LoginController extends GetxController {
  // 响应式状态
  final passwordList = List<int>.filled(6, -1).obs;
  final isSetupMode = false.obs;
  final firstPassword = Rxn<String>();
  final shakeKey = GlobalKey().obs;

  int _index = 0;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await authService.init();
    if (!authService.hasMasterPassword()) {
      isSetupMode.value = true;
    }
  }

  void updatePasswordList(int number) {
    if (_index >= 6) return;

    passwordList[_index] = number;
    _index++;

    if (_index == 6) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLogin();
      });
    }
  }

  void backspace() {
    if (_index > 0) {
      _index--;
      passwordList[_index] = -1;
    }
  }

  void _clearPasswordList() {
    passwordList.value = List<int>.filled(6, -1);
    _index = 0;
  }

  void _handleLogin() {
    final password = passwordList.join('');
    if (password.isEmpty) return;

    if (isSetupMode.value) {
      // 设置模式
      if (firstPassword.value == null) {
        // 第一次输入
        if (password.length < 4) {
          ToastUtil.showText(text: 'Password must be at least 4 digits');
          _clearPasswordList();
          return;
        }
        firstPassword.value = password;
        ToastUtil.showText(text: 'Please enter password again');
        _clearPasswordList();
      } else {
        // 第二次输入确认
        if (password == firstPassword.value) {
          _savePassword(password);
        } else {
          ToastUtil.showText(text: 'Passwords do not match');
          _clearPasswordList();
          firstPassword.value = null;
        }
      }
    } else {
      // 登录模式
      passwordList.value = List<int>.filled(6, -1);
      if (authService.login(password)) {
        ToastUtil.showText(text: 'Welcome back!');
        Get.offAll(() => const HomePage());
      } else {
        // 触发震动动画
        shakeKey.value = GlobalKey();
        update();
        _clearPasswordList();
      }
    }
  }

  Future<void> _savePassword(String password) async {
    final success = await authService.setMasterPassword(password);
    if (success) {
      ToastUtil.showText(text: 'Password set successfully');
      isSetupMode.value = false;
      firstPassword.value = null;
      Get.offAll(() => const HomePage());
    } else {
      ToastUtil.showText(text: 'Failed to set password');
    }
  }
}
