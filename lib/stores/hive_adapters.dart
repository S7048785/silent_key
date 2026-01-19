import 'package:hive/hive.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/models/Category.dart';

/// Hive类型适配器注册
class HiveAdapters {
  static void registerAdapters() {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(AccountAdapter());
  }
}

/// Category适配器
class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 0;

  @override
  Category read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();

    return Category(
      id: id,
      name: name,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeInt(obj.id)
      ..writeString(obj.name);
  }
}

/// Account适配器
class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 1;

  @override
  Account read(BinaryReader reader) {
    final id = reader.readInt();
    final categoryId = reader.readInt();
    final username = reader.readString();
    final password = reader.readString();
    final url = reader.readString();

    return Account(
      id: id,
      categoryId: categoryId,
      username: username,
      password: password,
      url: url,
    );
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeInt(obj.id)
      ..writeInt(obj.categoryId)
      ..writeString(obj.username)
      ..writeString(obj.password)
      ..writeString(obj.url);
  }
}
