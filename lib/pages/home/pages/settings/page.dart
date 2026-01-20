import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:silent_key/services/auth_service.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'package:silent_key/utils/ThemeManager.dart';
import 'package:silent_key/pages/login/page.dart';
import 'package:silent_key/utils/ToastUtil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showResetPasswordDialog() {
    String? firstPassword;
    String? confirmPassword;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('Enter your new master password (4-6 digits)'),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // 只保留数字
                  firstPassword = value.replaceAll(RegExp(r'[^0-9]'), '');
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // 只保留数字
                  confirmPassword = value.replaceAll(RegExp(r'[^0-9]'), '');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (firstPassword == null || firstPassword!.length < 6) {
                  ToastUtil.showText(text: 'Password must be 6 digits');
                  return;
                }
                if (firstPassword != confirmPassword) {
                  ToastUtil.showText(text: 'Passwords do not match');
                  return;
                }

                // 调用验证旧密码的对话框
                Navigator.pop(context);
                _showVerifyOldPasswordDialog(firstPassword!);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showVerifyOldPasswordDialog(String newPassword) {
    String? oldPassword;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verify Current Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('Enter your current master password to confirm'),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // 只保留数字
                  oldPassword = value.replaceAll(RegExp(r'[^0-9]'), '');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (oldPassword == null) {
                  ToastUtil.showText(text: 'Please enter your current password');
                  return;
                }

                // 调用服务层方法验证旧密码并更新密码
                final success = await authService.changeMasterPassword(oldPassword!, newPassword);
                Navigator.pop(context);

                if (success) {
                  ToastUtil.showText(text: 'Password changed successfully');
                } else {
                  ToastUtil.showText(text: 'Failed to change password. Some data may be corrupted.');
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout? You will need to enter your password to login again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                authService.logout();
                Navigator.pop(context);
                Get.offAll(() => const LoginPage());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () => ThemeManager.toggleTheme(),
              child: const Text('Toggle Theme'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _showResetPasswordDialog,
              child: const Text('Reset Password'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 2),
              ),
              onPressed: _showLogoutDialog,
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
