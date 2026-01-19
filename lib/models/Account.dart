import 'package:hive/hive.dart';
/// 账户模型
@HiveType(typeId: 1)
class Account {
  @HiveField(0)
  int id;

  @HiveField(1)
  int categoryId;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  String url;

  Account({
    required this.id,
    required this.categoryId,
    required this.username,
    required this.password,
    this.url = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'username': username,
      'password': password,
      'url': url,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] ?? 0,
      categoryId: map['categoryId'] ?? 0,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Account copyWith({
    int? id,
    int? categoryId,
    String? username,
    String? password,
    String? url,
  }) {
    return Account(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
    );
  }
}
