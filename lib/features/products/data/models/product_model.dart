import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.brand,
    required super.price,
    required super.originalPrice,
    required super.stock,
    required super.image,
    required super.badges,
    required super.categoryId,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> j) {
    final images = (j['images'] as List?)?.cast<String>() ?? const <String>[];
    final price = (j['price'] as num).toDouble();
    return ProductModel(
      id: j['id'] as String,
      title: j['title'] as String,
      brand: (j['brand'] as String?) ?? '',
      price: price,
      originalPrice: (j['originalPrice'] as num?)?.toDouble() ?? price,
      stock: (j['stock'] as num?)?.toInt() ?? 0,
      image: (j['image'] as String?) ?? (images.isNotEmpty ? images.first : ''),
      badges: (j['badges'] as List?)?.cast<String>() ?? const <String>[],
      categoryId: (j['categoryId'] as String?) ?? '',
      rating: (j['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  factory ProductModel.fromEntity(ProductEntity p) => ProductModel(
    id: p.id,
    title: p.title,
    brand: p.brand,
    price: p.price,
    originalPrice: p.originalPrice,
    stock: p.stock,
    image: p.image,
    badges: p.badges,
    categoryId: p.categoryId,
    rating: p.rating,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'brand': brand,
    'price': price,
    'originalPrice': originalPrice,
    'stock': stock,
    'image': image,
    'badges': badges,
    'categoryId': categoryId,
    'rating': rating,
  };
}
