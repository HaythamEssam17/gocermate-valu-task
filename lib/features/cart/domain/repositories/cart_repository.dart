import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item_patch.dart';
import 'package:grocermate/features/cart/domain/entities/cart_snapshot.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

abstract interface class CartRepository {
  Stream<CartSnapshot> watch();

  Future<CartOutcome> add(ProductEntity product, {int qty = 1});

  Future<CartOutcome> setQty(String productId, int qty);

  Future<void> remove(Set<String> ids, {bool fromSaved = false});

  Future<void> move(Set<String> ids, {required bool toSaved});

  Future<void> applyPatches(List<CartItemPatch> patches);

  Future<void> restore(List<CartItem> items);

  Future<Result<void>> refreshStock();
}
