import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/app_button_type.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:grocermate/shared/widgets/cart_widgets/qty_stepper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({
    super.key,
    required this.product,
    required this.qty,
    required this.onQty,
  });

  final ProductEntity product;
  final int qty;
  final ValueChanged<int> onQty;

  @override
  Widget build(BuildContext context) {
    final maxQty = product.stock;

    return AppCard(
      child: product.isOutOfStock
          ? const AppButton(text: 'Out of stock', type: AppButtonType.secondary)
          : Row(
              children: [
                QtyStepper(
                  qty: qty,
                  onMinus: () => onQty(qty > 1 ? qty - 1 : 1),
                  onPlus: () => onQty(qty < maxQty ? qty + 1 : qty),
                ),
                getSpaceWidth(context, 16),
                Expanded(
                  child: AppButton(
                    text: 'Add  -  ${(product.price * qty).formatMoney()}',
                    icon: LucideIcons.shoppingCartPlus,
                    onPressed: () {
                      context.read<CartBloc>().add(
                        CartItemAdded(product, qty: qty),
                      );
                      onQty(1);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
