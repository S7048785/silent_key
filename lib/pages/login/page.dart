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
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    children: [
                      for (int i = 0; i < 6; i++)
                        Obx(() => Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                color: controller.passwordList[i] >= 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                            )),
                    ],
                  ),
                )),
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
                                    key: ValueKey('button_${i * 3 + j + 1}'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(78, 78),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.updatePasswordList(i * 3 + j + 1);
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
                              controller.updatePasswordList(0);
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
                            onPressed: controller.backspace,
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
          onNumberInput: controller.updatePasswordList,
          onBackspace: controller.backspace,
        ),
      ],
    );
  }
}
