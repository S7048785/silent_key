import 'package:get/get.dart';
import 'package:silent_key/models/Category.dart';
import 'package:silent_key/stores/hive_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = hiveService.getAllCategories();
  }

  Future<void> addCategory(String name) async {
    int id = await hiveService.addCategory(Category(name: name, id: 0));
    categories.add(Category(name: name, id: id));
  }

  Future<void> deleteCategory(Category category) async {
    await hiveService.deleteCategory(category.id);
    categories.remove(category);
  }
}
