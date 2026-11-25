import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.brand,
    required super.image,
    required super.categoryId,
    required super.unitPrice,
    required super.originalPrice,
    required super.stock,
    required super.qty,
  });

  factory CartItemModel.fromEntity(CartItem i) => CartItemModel(
    productId: i.productId,
    title: i.title,
    brand: i.brand,
    image: i.image,
    categoryId: i.categoryId,
    unitPrice: i.unitPrice,
    originalPrice: i.originalPrice,
    stock: i.stock,
    qty: i.qty,
  );

  factory CartItemModel.fromJson(Map<String, dynamic> j) => CartItemModel(
    productId: j['product_id'] as String,
    title: j['title'] as String,
    brand: (j['brand'] as String?) ?? '',
    image: (j['image'] as String?) ?? '',
    categoryId: (j['category_id'] as String?) ?? '',
    unitPrice: (j['unit_price'] as num).toDouble(),
    originalPrice: (j['original_price'] as num).toDouble(),
    stock: (j['stock'] as num).toInt(),
    qty: (j['qty'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'title': title,
    'brand': brand,
    'image': image,
    'category_id': categoryId,
    'unit_price': unitPrice,
    'original_price': originalPrice,
    'stock': stock,
    'qty': qty,
  };

  static List<CartItem> listFromJson(dynamic raw) {
    if (raw is! List) return const [];
    final out = <CartItem>[];
    for (final e in raw) {
      try {
        out.add(CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)));
      } catch (_) {}
    }
    return out;
  }

  static List<Map<String, dynamic>> listToJson(List<CartItem> items) =>
      items.map((e) => CartItemModel.fromEntity(e).toJson()).toList();
}
