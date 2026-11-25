import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item_patch.dart';

class ResolvedOrder {
  const ResolvedOrder({
    required this.items,
    required this.patches,
    required this.removedIds,
  });
  final List<CartItem> items;
  final List<CartItemPatch> patches;
  final Set<String> removedIds;
}
