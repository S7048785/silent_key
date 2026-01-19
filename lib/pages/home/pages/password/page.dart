import 'package:flutter/material.dart';
import 'package:silent_key/controllers/CategoryController.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/models/Category.dart';
import 'package:get/get.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'package:silent_key/utils/ToastUtil.dart';
import 'widgets/index.dart' as widgets;

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除分类 ${category.name}？'),
        content: const Text('此操作不可撤销'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    ).then((result) {
      if (result == true) {
        final accounts = hiveService.getAccountsByCategoryId(category.id);
        if (accounts.isNotEmpty) {
          ToastUtil.showText('分类下有账户，无法删除', context: context);
          return;
        }
        Get.find<CategoryController>().deleteCategory(category);
      }
    });
  }

  void _showBottomSheet(Account account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: widgets.BottomSheetContent(account: account),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: RefreshIndicator(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            spacing: 8,
            children: [
              const widgets.SearchBar(),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  final controller = Get.find<CategoryController>();
                  return ListView.builder(
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      return widgets.CategoryItem(
                        category: controller.categories[index],
                        onDelete: () => _deleteCategory(controller.categories[index]),
                        onAccountTap: _showBottomSheet,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          Get.find<CategoryController>().loadCategories();
          ToastUtil.showText("刷新成功", context: context);
        },
      ),
    );
  }
}
