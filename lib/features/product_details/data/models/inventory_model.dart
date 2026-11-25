import 'package:grocermate/features/product_details/domain/entities/inventory.dart';

class InventoryModel extends Inventory {
  const InventoryModel({
    required super.productId,
    required super.stock,
    required super.backorderable,
    required super.etaDays,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> j) => InventoryModel(
    productId: j['productId'] as String,
    stock: (j['stock'] as num).toInt(),
    backorderable: (j['backorderable'] as bool?) ?? false,
    etaDays: (j['etaDays'] as num?)?.toInt() ?? 0,
  );
}
