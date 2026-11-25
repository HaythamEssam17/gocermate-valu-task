import '../../../../../core/storage/json_store.dart';
import '../../../domain/entities/cart_snapshot.dart';
import '../../models/cart_item_model.dart';

class CartLocalDataSource {
  CartLocalDataSource(this._store);
  final JsonStore _store;

  CartSnapshot read() => CartSnapshot(
    cart: CartItemModel.listFromJson(_store.read('cart')),
    saved: CartItemModel.listFromJson(_store.read('saved')),
  );

  Future<void> write(CartSnapshot s) async {
    await _store.write('cart', CartItemModel.listToJson(s.cart));
    await _store.write('saved', CartItemModel.listToJson(s.saved));
  }
}
