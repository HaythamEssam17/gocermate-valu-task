import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/checkout/domain/repositories/checkout_repository.dart';

class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repo, this._flags);
  final CheckoutRepository _repo;
  final FlagsRepository _flags;

  Future<Result<PurchaseResult>> call(
    List<CartItem> items, {
    String? idempotencyKey,
  }) {
    final f = _flags.current;
    return _repo.placeOrder(
      PurchaseRequest.fromCartItems(
        items,
        revalidatePrices: f.enablePriceRevalidation,
        idempotencyKey: idempotencyKey,
        currency: f.currency,
      ),
    );
  }
}
