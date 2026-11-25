import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/buttons/app_icon_button.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/core/widgets/text_widgets/price_text.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../features/cart/presentation/bloc/cart_bloc.dart';
import 'qty_stepper.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    if (product.isOutOfStock) {
      return AppText(context.tr.outOfStock, color: context.appColors.error);
    }

    return BlocSelector<CartBloc, CartState, int>(
      selector: (s) => s.qtyOf(product.id),
      builder: (context, qty) {
        final bloc = context.read<CartBloc>();
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: qty == 0
              ? Row(
                  key: ValueKey<String>('add_${product.id}'),
                  children: [
                    PriceText(
                      price: product.price,
                      originalPrice: product.originalPrice,
                    ),
                    const Spacer(),

                    Center(
                      child: AppIconButton(
                        icon: const Icon(LucideIcons.shoppingCartPlus),
                        onTap: () => bloc.add(CartItemAdded(product)),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PriceText(
                      price: product.price,
                      originalPrice: product.originalPrice,
                    ),
                    QtyStepper(
                      key: ValueKey<String>('stepper_${product.id}'),
                      qty: qty,
                      onMinus: () =>
                          bloc.add(CartQtyChanged(product.id, qty - 1)),
                      onPlus: () => bloc.add(CartItemAdded(product)),
                      compact: true,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
