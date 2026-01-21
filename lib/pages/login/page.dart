import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/pages/login/controller.dart';
import 'SnakeAnimation.dart';
import 'keyboard_listener.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 16,
              children: [
                // 标题部分
                _buildTitleSection(controller, context),
                const SizedBox(height: 24),
                // 密码输入键盘
                _buildPasswordKeyboard(controller),
              ],
            ),
          ),
        ),
        LoginKeyboardListener(
          onNumberInput: controller.updatePasswordList,
          onBackspace: controller.backspace,
        ),
      ],
    );
  }

  Widget _buildTitleSection(LoginController controller, BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Obx(() => Text(
              controller.isSetupMode.value
                  ? "Set Master Password"
                  : "Enter App Password",
              style: const TextStyle(fontSize: 24),
            )),
        const SizedBox(height: 12),
        Obx(() => SpringShakeAnimation(
              key: controller.shakeKey.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: List.generate(
                  6,
                  (index) => _buildPasswordIndicator(index, controller, context),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildPasswordIndicator(int index, LoginController controller, BuildContext context) {
    return Obx(() => Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            color: controller.passwordList[index] >= 0
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.grey, width: 1),
          ),
        ));
  }

  /// 构建密码输入键盘
  Widget _buildPasswordKeyboard(LoginController controller) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              for (int row = 0; row < 3; row++) _buildNumberRow(row, controller),
            ],
          ),
          const SizedBox(height: 20),
          _buildBottomRow(controller),
        ],
      ),
    );
  }
  /// 构建数字行 1-9
  Widget _buildNumberRow(int row, LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        for (int col = 0; col < 3; col++)
          _buildNumberButton(row * 3 + col + 1, controller),
      ],
    );
  }

  /// 构建数字按钮
   Widget _buildNumberButton(int number, LoginController controller) {
    return ElevatedButton(
      key: ValueKey('button_$number'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(78, 78),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      onPressed: () => controller.updatePasswordList(number),
      child: Text('$number'),
    );
  }
  /// 按钮0
  Widget _buildBottomRow(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
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
          onPressed: () => controller.updatePasswordList(0),
          child: const Text('0'),
        ),
        _buildDeleteButton(controller),
      ],
    );
  }
  /// 构建删除按钮
  Widget _buildDeleteButton(LoginController controller) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(78, 78),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      onPressed: controller.backspace,
      child: const Text(
        'Delete',
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
    );
  }
}
