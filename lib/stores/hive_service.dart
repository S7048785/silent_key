import 'package:hive/hive.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/models/Category.dart';
import 'dart:async';

/// Hive数据库服务类
class HiveService {
  static const String _categoryBoxName = 'categories';
  static const String _accountBoxName = 'accounts';
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  late Box<Category> _categoryBox;
  late Box<Account> _accountBox;

  // 监听器相关
  final StreamController<List<Category>> _categoriesStreamController =
      StreamController<List<Category>>.broadcast();
  final StreamController<List<Account>> _accountsStreamController =
      StreamController<List<Account>>.broadcast();

  Stream<List<Category>> get categoriesStream => _categoriesStreamController.stream;
  Stream<List<Account>> get accountsStream => _accountsStreamController.stream;

  /// 初始化Hive数据库
  Future<void> init() async {
    if (!Hive.isBoxOpen(_categoryBoxName)) {
      _categoryBox = await Hive.openBox<Category>(_categoryBoxName);
    } else {
      _categoryBox = Hive.box<Category>(_categoryBoxName);
    }

    if (!Hive.isBoxOpen(_accountBoxName)) {
      _accountBox = await Hive.openBox<Account>(_accountBoxName);
    } else {
      _accountBox = Hive.box<Account>(_accountBoxName);
    }

    // 监听盒子变化
    _categoryBox.watch().listen((event) {
      _categoriesStreamController.add(getAllCategories());
    });
    _accountBox.watch().listen((event) {
      _accountsStreamController.add(getAllAccounts());
    });

    await _initializeDefaultData();
  }

  Future<void> _initializeDefaultData() async {
    if (_categoryBox.isEmpty) {
      final defaultCategories = [
        Category(id: 1, name: '社交媒体'),
        Category(id: 2, name: '邮箱账户'),
        Category(id: 3, name: '购物网站'),
      ];

      for (final category in defaultCategories) {
        await _categoryBox.add(category);
      }
    }
  }

  // ==================== Category CRUD ====================

  /// 添加分类
  Future<int> addCategory(Category category) async {
    final id = _generateCategoryId();
    final newCategory = category.copyWith(id: id);
    await _categoryBox.add(newCategory);
    return id;
  }

  /// 获取所有分类（不包含账号信息）
  List<Category> getAllCategories() {
    return _categoryBox.values.toList().cast<Category>();
  }

  /// 根据ID获取分类
  Category? getCategoryById(int id) {
    try {
      return _categoryBox.values.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 更新分类
  Future<bool> updateCategory(int id, Category category) async {
    try {
      final key = _categoryBox.keys.firstWhere((k) {
        final cat = _categoryBox.get(k);
        return cat?.id == id;
      });
      await _categoryBox.put(key, category.copyWith(id: id));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 删除分类（同时删除该分类下的所有账户）
  Future<bool> deleteCategory(int id) async {
    try {
      // 先删除该分类下的所有账户
      await deleteAccountsByCategoryId(id);
      // 再删除分类
      final key = _categoryBox.keys.firstWhere((k) {
        final cat = _categoryBox.get(k);
        return cat?.id == id;
      });
      await _categoryBox.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 生成唯一分类ID
  int _generateCategoryId() {
    if (_categoryBox.isEmpty) return 1;
    return _categoryBox.values.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  // ==================== Account CRUD ====================

  /// 添加账户
  Future<int> addAccount(Account account) async {
    final id = _generateAccountId(account.categoryId);
    final newAccount = account.copyWith(id: id);
    await _accountBox.add(newAccount);
    return id;
  }

  /// 查询指定Category下的所有Account
  List<Account> getAccountsByCategoryId(int categoryId) {
    return _accountBox.values.where((a) => a.categoryId == categoryId).toList().cast<Account>();
  }

  /// 获取所有账户
  List<Account> getAllAccounts() {
    return _accountBox.values.toList();
  }

  /// 根据用户名查询账户
  List<Account> getAccountsByUsername(String username) {
    return _accountBox.values.where((a) => a.username == username).toList();
  }

  /// 根据ID获取账户
  Account? getAccountById(int id) {
    try {
      return _accountBox.values.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 更新账户
  Future<bool> updateAccount(int id, Account account) async {
    try {
      final key = _accountBox.keys.firstWhere((k) {
        final acc = _accountBox.get(k);
        return acc?.id == id;
      });
      await _accountBox.put(key, account.copyWith(id: id));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 删除账户
  Future<bool> deleteAccount(int id) async {
    try {
      final key = _accountBox.keys.firstWhere((k) {
        final acc = _accountBox.get(k);
        return acc?.id == id;
      });
      await _accountBox.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 删除指定分类下的所有账户
  Future<void> deleteAccountsByCategoryId(int categoryId) async {
    final keys = _accountBox.keys.where((k) {
      final acc = _accountBox.get(k);
      return acc?.categoryId == categoryId;
    }).toList();
    await _accountBox.deleteAll(keys);
  }

  /// 生成唯一账户ID（按分类）
  int _generateAccountId(int categoryId) {
    final accountsInCategory = _accountBox.values.where((a) => a.categoryId == categoryId);
    if (accountsInCategory.isEmpty) return 1;
    return accountsInCategory.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  // ==================== 搜索功能 ====================

  /// 根据用户名搜索
  List<Account> searchByUsername(String keyword) {
    return _accountBox.values
        .where((a) => a.username.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  /// 根据分类名搜索
  List<Category> searchByCategoryName(String keyword) {
    return _categoryBox.values
        .where((c) => c.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  // ==================== 关闭数据库 ====================

  Future<void> close() async {
    await _categoryBox.close();
    await _accountBox.close();
    await _categoriesStreamController.close();
    await _accountsStreamController.close();
  }
}

/// 全局Hive服务实例
final hiveService = HiveService();
