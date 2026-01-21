import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/services/auth_service.dart';
import 'package:silent_key/utils/ThemeManager.dart';
import 'package:silent_key/pages/login/page.dart';
import 'package:silent_key/utils/ToastUtil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showResetPasswordDialog() {
    String? firstPassword;
    String? confirmPassword;

    showDialog(
      context: Get.context!,
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
      context: Get.context!,
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
      context: Get.context!,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(
            () => _SettingsTile(
              title: 'Dark Mode',
              subtitle: 'Toggle between light and dark theme',
              trailing: Switch(
                value: ThemeManager.themeMode.value == ThemeMode.dark,
                onChanged: (_) => ThemeManager.toggleTheme(),
              ),
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Security',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          _SettingsTile(
            title: 'Change Password',
            subtitle: 'Reset your master password',
            onTap: _showResetPasswordDialog,
          ),
          const Divider(indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          _SettingsTile(
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: _showLogoutDialog,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
