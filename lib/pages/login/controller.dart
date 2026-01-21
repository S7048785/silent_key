import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/services/auth_service.dart';
import 'package:silent_key/utils/ToastUtil.dart';
import 'package:silent_key/pages/home/page.dart';
import 'SnakeAnimation.dart';

class LoginController extends GetxController {
  // 响应式状态
  final passwordList = List<int>.filled(6, -1).obs;
  final isSetupMode = false.obs;
  final firstPassword = Rxn<String>();
  final shakeKey = GlobalKey<SpringShakeAnimationState>().obs;

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

  // 更新密码列表
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

  // 回退删除
  void backspace() {
    if (_index > 0) {
      _index--;
      passwordList[_index] = -1;
    }
  }

  // 清空密码列表
  void _clearPasswordList() {
    passwordList.value = List<int>.filled(6, -1);
    _index = 0;
  }

  // 处理登录
  void _handleLogin() {
    final password = passwordList.join('');
    if (password.isEmpty) return;

    if (isSetupMode.value) {
      // 设置模式
      if (firstPassword.value == null) {
        // 第一次输入
        if (password.length < 6) {
          ToastUtil.showText(text: '密码必须6位');
          _clearPasswordList();
          return;
        }
        firstPassword.value = password;
        ToastUtil.showText(text: '请再次输入密码');
        _clearPasswordList();
      } else {
        // 第二次输入确认
        if (password == firstPassword.value) {
          _savePassword(password);
        } else {
          ToastUtil.showText(text: '两次输入密码不一致');
          _clearPasswordList();
          firstPassword.value = null;
        }
      }
    } else {

      if (authService.login(password)) {
        print('Login password: ${passwordList.join('')}\n');

        ToastUtil.showText(text: '欢迎回来！');
        Get.offAll(() => const HomePage());
      } else {
        // 触发抖动动画
        SpringShakeAnimation.shake(shakeKey.value);
      }
    }
    _clearPasswordList();

  }

  Future<void> _savePassword(String password) async {
    final success = await authService.setMasterPassword(password);
    if (success) {
      ToastUtil.showText(text: '密码设置成功');
      isSetupMode.value = false;
      firstPassword.value = null;
      Get.offAll(() => const HomePage());
    } else {
      ToastUtil.showText(text: '设置密码失败');
    }
  }
}
