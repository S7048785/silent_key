import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/controllers/CategoryController.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'package:silent_key/utils/ToastUtil.dart';
import 'info_row.dart';
import 'action_buttons.dart';

class BottomSheetContent extends StatefulWidget {
  final Account account;

  const BottomSheetContent({super.key, required this.account});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController urlController;
  bool obscurePassword = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.account.username);
    passwordController = TextEditingController(text: widget.account.password);
    urlController = TextEditingController(text: widget.account.url);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    urlController.dispose();
    super.dispose();
  }

  void _copyPassword(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ToastUtil.showText(text: 'Copied to clipboard');
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete account "${widget.account.username}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await hiveService.deleteAccount(widget.account.id);
              Get.find<CategoryController>().loadCategories();
              Get.back(); // 关闭 BottomSheet
              Navigator.pop(context); // 关闭对话框
              ToastUtil.showText(text: 'Deleted');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAccount() async {
    final newUsername = usernameController.text.trim();
    final newPassword = passwordController.text.trim();
    final newUrl = urlController.text.trim();

    if (newUsername.isEmpty) {
      ToastUtil.showText(text: 'Username cannot be empty');
      return;
    }
    if (newPassword.isEmpty) {
      ToastUtil.showText(text: 'Password cannot be empty');
      return;
    }

    final updatedAccount = widget.account.copyWith(
      username: newUsername,
      password: newPassword,
      url: newUrl,
    );

    await hiveService.updateAccount(widget.account.id, updatedAccount);
    Get.find<CategoryController>().loadCategories();
    ToastUtil.showText(text: 'Saved');
    setState(() {
      isEditing = false;
    });
  }

  void _cancelEdit() {
    usernameController.text = widget.account.username;
    passwordController.text = widget.account.password;
    urlController.text = widget.account.url;
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryController = Get.find<CategoryController>();
    final category = categoryController.categories.firstWhereOrNull(
      (c) => c.id == widget.account.categoryId,
    );

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖拽指示器
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // 头部信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.account.username,
                              style: theme.textTheme.titleLarge,
                            ),
                            if (category != null)
                              Text(
                                category.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isEditing
                              ? Icons.close_outlined
                              : Icons.edit_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                // 表单区域
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Icons.person_outline,
                        label: 'Username',
                        controller: usernameController,
                        enabled: isEditing,
                        theme: theme,
                        showCopy: !isEditing && widget.account.username.isNotEmpty,
                        onCopy: () => _copyPassword(widget.account.username),
                      ),
                      const SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.lock_outline,
                        label: 'Password',
                        controller: passwordController,
                        enabled: isEditing,
                        obscureText: obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.link_outlined,
                        label: 'URL',
                        controller: urlController,
                        enabled: isEditing,
                        theme: theme,
                        showCopy: !isEditing && widget.account.url.isNotEmpty,
                        onCopy: () => _copyPassword(widget.account.url),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 操作按钮
                ActionButtons(
                  isEditing: isEditing,
                  onSave: _saveAccount,
                  onCancel: _cancelEdit,
                  onCopyPassword: () => _copyPassword(widget.account.password),
                  onCopyAndClose: () {
                    Get.back();
                    _copyPassword(widget.account.password);
                  },
                ),
                const SizedBox(height: 12),
                // 删除按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton.icon(
                    onPressed: _confirmDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
