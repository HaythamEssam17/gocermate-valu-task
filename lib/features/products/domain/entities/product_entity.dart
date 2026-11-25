import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.stock,
    required this.image,
    required this.badges,
    required this.categoryId,
    required this.rating,
  });

  final String id;
  final String title;
  final String brand;
  final double price;
  final double originalPrice;
  final int stock;
  final String image;
  final List<String> badges;
  final String categoryId;
  final double rating;

  bool get isOutOfStock => stock <= 0;

  bool get isLowStock => stock > 0 && stock <= 10;

  bool get hasDiscount => originalPrice > price;

  int get discountPercent => hasDiscount
      ? (((originalPrice - price) / originalPrice) * 100).round()
      : 0;

  ProductEntity copyWith({double? price, double? originalPrice, int? stock}) =>
      ProductEntity(
        id: id,
        title: title,
        brand: brand,
        price: price ?? this.price,
        originalPrice: originalPrice ?? this.originalPrice,
        stock: stock ?? this.stock,
        image: image,
        badges: badges,
        categoryId: categoryId,
        rating: rating,
      );

  @override
  List<Object?> get props => [
    id,
    title,
    brand,
    price,
    originalPrice,
    stock,
    image,
    badges,
    categoryId,
    rating,
  ];
}
