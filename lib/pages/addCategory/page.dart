import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/controllers/CategoryController.dart';
import 'package:silent_key/utils/ToastUtil.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveCategory() async {
    final controller = Get.find<CategoryController>();
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ToastUtil.showText(text: '请输入分类名称');
      return;
    }

    // 检查分类名是否已存在
    final existingCategories = controller.categories;
    if (existingCategories.any((c) => c.name.toLowerCase() == name.toLowerCase())) {
      ToastUtil.showText(text: '分类名称已存在');
      return;
    }
    await controller.addCategory(name);

    ToastUtil.showText(text: '添加成功');
    Get.back(result: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        actions: [
          TextButton(
            onPressed: _saveCategory,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveCategory(),
            ),
            ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      )
    );
  }
}
