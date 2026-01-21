import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/controllers/CategoryController.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/models/Category.dart';
import 'package:silent_key/pages/addCategory/page.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'package:silent_key/utils/ToastUtil.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  Category? _selectedCategory;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveAccount() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final url = _urlController.text.trim();

    if (username.isEmpty) {
      ToastUtil.showText(text: '请输入用户名');
      return;
    }

    if (password.isEmpty) {
      ToastUtil.showText(text: '请输入密码');
      return;
    }

    if (url.isNotEmpty && !Uri.parse(url).isAbsolute) {
      ToastUtil.showText(text: '请输入有效的URL');
      return;
    }

    final categoryController = Get.find<CategoryController>();
    if (categoryController.categories.isEmpty) {
      ToastUtil.showText(text: '请先添加分类');
      return;
    }

    if (_selectedCategory == null) {
      ToastUtil.showText(text: '请选择分类');
      return;
    }

    final account = Account(
      id: 0,
      categoryId: _selectedCategory!.id,
      username: username,
      password: password,
      url: url,
    );

    await hiveService.addAccount(account);

     ToastUtil.showText(text: '已添加');
    _usernameController.clear();
    _passwordController.clear();
    _urlController.clear();
    Get.back(result: true);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加账号')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类选择区域
            Obx(() {
              final categoryController = Get.find<CategoryController>();
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.dividerColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Category>(
                      isExpanded: true,
                      value: _selectedCategory,
                      hint: const Text('请选择分类'),
                      items: categoryController.categories.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Row(
                            children: [
                              Text(category.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            // 添加分类按钮
            TextButton.icon(
              onPressed: () => Get.to(const AddCategoryPage()),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('添加分类'),
            ),
            const SizedBox(height: 24),
            // 表单区域
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    // 用户名输入框
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: '用户名',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: false,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    // 密码输入框
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '密码',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: false,
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                    ),
                    // 网址输入框
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: '网址（可选）',
                        prefixIcon: const Icon(Icons.link_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: false,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _saveAccount(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 保存按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveAccount,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
