import 'package:go_router/go_router.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/app_button_type.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/buttons/app_icon_button.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/shared/widgets/cart_widgets/qty_stepper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.isSaved,
    required this.selectionMode,
    required this.selected,
    required this.onToggleSelect,
    required this.onQtyChanged,
    required this.onRemove,
    required this.onMove,
  });

  final CartItem item;
  final bool isSaved;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onToggleSelect;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;
  final VoidCallback onMove;

  @override
  Widget build(BuildContext context) {
    final warning = item.isOutOfStock
        ? context.tr.outOfStock
        : item.exceedsStock
        ? context.tr.onlyStockLeft(item.stock)
        : null;

    return AppCard(
      padding: const EdgeInsets.all(8),
      color: selected
          ? context.appColors.card.withAlpha(120)
          : context.appColors.surface5,
      child: InkWell(
        onLongPress: onToggleSelect,
        onTap: selectionMode
            ? onToggleSelect
            : () => context.push(AppRoutes.product, extra: item.productId),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 28),
                child: Icon(
                  selected ? LucideIcons.circleCheckBig : LucideIcons.circle,
                  color: selected
                      ? context.appColors.primary
                      : context.appColors.border,
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 78,
                height: 78,
                child: AppNetworkImage(item.image),
              ),
            ),
            getSpaceWidth(context, 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                    item.brand,
                    fontSize: 12,
                    color: context.textColors.lightText,
                  ),
                  if (warning != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: AppText(
                        warning,
                        fontSize: 12,
                        color: context.appColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  getSpaceHeight(context, 8),
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          item.lineTotal.formatMoney(),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      if (!isSaved && !selectionMode) ...[
                        QtyStepper(
                          qty: item.qty,
                          onMinus: () => onQtyChanged(item.qty - 1),
                          onPlus: () => onQtyChanged(item.qty + 1),
                        ),
                      ],
                      if (isSaved) AppText('${context.tr.qty} ${item.qty}'),
                    ],
                  ),
                  if (!selectionMode) ...[
                    getSpaceHeight(context, 16),
                    Row(
                      children: [
                        AppButton(
                          text: isSaved
                              ? context.tr.moveToCart
                              : context.tr.saveForLater,
                          onPressed: onMove,
                          icon: isSaved
                              ? LucideIcons.shoppingCartPlus
                              : LucideIcons.bookmarkPlus,
                          isFullWidth: false,
                          type: AppButtonType.secondary,
                        ),
                        const Spacer(),
                        AppIconButton(
                          icon: Icon(
                            LucideIcons.trash,
                            color: context.appColors.error,
                          ),
                          onTap: onRemove,
                          radius: 100,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
