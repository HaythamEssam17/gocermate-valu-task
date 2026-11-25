import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';

class CheckoutArgs {
  const CheckoutArgs({this.items, this.resume});
  final List<CartItem>? items;
  final OutboxEntry? resume;
}
