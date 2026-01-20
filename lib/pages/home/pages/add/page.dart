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
      ToastUtil.showText(text: 'Please enter a username');
      return;
    }

    if (password.isEmpty) {
      ToastUtil.showText(text: 'Please enter a password');
      return;
    }

    if (url.isNotEmpty && !Uri.parse(url).isAbsolute) {
      ToastUtil.showText(text: 'Please enter a valid URL');
      return;
    }

    final categoryController = Get.find<CategoryController>();
    if (categoryController.categories.isEmpty) {
      ToastUtil.showText(text: 'Please add a category first');
      return;
    }

    if (_selectedCategory == null) {
      ToastUtil.showText(text: 'Please select a category');
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

     ToastUtil.showText(text: 'Account added successfully');
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
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account')
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
                      hint: const Text('Select the category'),
                      items: categoryController.categories.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category.name),
                                size: 20,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 12),
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
              label: const Text('New Category'),
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
                        labelText: 'User',
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
                        labelText: 'Password',
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
                        labelText: 'URL (Optional)',
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
                  'Save',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('社交')) return Icons.people_outline;
    if (name.contains('邮箱')) return Icons.email_outlined;
    if (name.contains('购物')) return Icons.shopping_bag_outlined;
    if (name.contains('银行') || name.contains('金融')) return Icons.account_balance_outlined;
    if (name.contains('游戏')) return Icons.sports_esports_outlined;
    if (name.contains('工作') || name.contains('办公')) return Icons.work_outline;
    if (name.contains('视频')) return Icons.movie_outlined;
    if (name.contains('音乐')) return Icons.music_note_outlined;
    if (name.contains('云')) return Icons.cloud_outlined;
    return Icons.folder_outlined;
  }
}
