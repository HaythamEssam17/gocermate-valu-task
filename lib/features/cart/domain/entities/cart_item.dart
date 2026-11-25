import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.productId,
    required this.title,
    required this.brand,
    required this.image,
    required this.categoryId,
    required this.unitPrice,
    required this.originalPrice,
    required this.stock,
    required this.qty,
  });

  factory CartItem.fromProduct(ProductEntity product, {int qty = 1}) =>
      CartItem(
        productId: product.id,
        title: product.title,
        brand: product.brand,
        image: product.image,
        categoryId: product.categoryId,
        unitPrice: product.price,
        originalPrice: product.originalPrice,
        stock: product.stock,
        qty: qty,
      );

  final String productId;
  final String title;
  final String brand;
  final String image;
  final String categoryId;
  final double unitPrice;
  final double originalPrice;
  final int stock;
  final int qty;

  double get listPrice => math.max(originalPrice, unitPrice);
  double get lineTotal => (unitPrice * qty).roundAmountToDouble();
  double get lineDiscount =>
      ((listPrice - unitPrice) * qty).roundAmountToDouble();
  bool get isOutOfStock => stock <= 0;
  bool get exceedsStock => qty > stock;

  CartItem copyWith({
    double? unitPrice,
    double? originalPrice,
    int? stock,
    int? qty,
  }) => CartItem(
    productId: productId,
    title: title,
    brand: brand,
    image: image,
    categoryId: categoryId,
    unitPrice: unitPrice ?? this.unitPrice,
    originalPrice: originalPrice ?? this.originalPrice,
    stock: stock ?? this.stock,
    qty: qty ?? this.qty,
  );

  @override
  List<Object?> get props => [
    productId,
    title,
    brand,
    image,
    categoryId,
    unitPrice,
    originalPrice,
    stock,
    qty,
  ];
}
