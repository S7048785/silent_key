import 'package:hive/hive.dart';
/// 分类模型
@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  Category({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  Category copyWith({
    int? id,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
