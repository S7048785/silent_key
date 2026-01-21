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
          title: const Text('重置密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('输入新的主密码（6位数字）'),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: '新密码',
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
                  labelText: '确认密码',
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
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (firstPassword == null || firstPassword!.length < 6) {
                  ToastUtil.showText(text: '密码必须6位');
                  return;
                }
                if (firstPassword != confirmPassword) {
                  ToastUtil.showText(text: '两次输入密码不一致');
                  return;
                }
                Navigator.pop(context);
                _showVerifyOldPasswordDialog(firstPassword!);
              },
              child: const Text('下一步'),
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
          title: const Text('验证当前密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('请输入当前主密码以确认'),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: '当前主密码',
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
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (oldPassword == null) {
                  ToastUtil.showText(text: '请输入当前主密码');
                  return;
                }

                final success = await authService.changeMasterPassword(oldPassword!, newPassword);
                Navigator.pop(context);

                if (success) {
                  ToastUtil.showText(text: '主密码已成功修改');
                } else {
                  ToastUtil.showText(text: '修改主密码失败，部分数据可能已损坏');
                }
              },
              child: const Text('确认'),
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
          title: const Text('注销登录'),
          content: const Text('确定要注销登录吗？您需要重新输入主密码才能登录。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                authService.logout();
                Navigator.pop(context);
                Get.offAll(() => const LoginPage());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('退出登录', style: TextStyle(color: Colors.white)),
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
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              '外观',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(
            () => _SettingsTile(
              title: '深色模式',
              subtitle: '切换浅色和深色主题',
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
              '安全',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          _SettingsTile(
            title: '修改主密码',
            subtitle: '重置您的主密码',
            onTap: _showResetPasswordDialog,
          ),
          const Divider(indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              '账户',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          _SettingsTile(
            title: '退出登录',
            subtitle: '退出当前账户',
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
