import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
    id: j['id'] as String,
    name: j['name'] as String,
    icon: (j['icon'] as String?) ?? '',
  );
}
