import 'package:material_ui/material_ui.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';

import '../../../core/config/app_flags.dart';
import '../../../features/cart/domain/entities/cart_totals.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.totals, required this.flags});
  final CartTotals totals;
  final AppFlags flags;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value, {bool bold = false, Color? color}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  label,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  fontSize: bold ? 16 : 14,
                ),
              ),
              AppText(
                value,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                fontSize: bold ? 18 : 14,
                color: color,
              ),
            ],
          ),
        );

    final progress = flags.freeDeliveryThreshold == 0
        ? 1.0
        : (totals.subtotal / flags.freeDeliveryThreshold).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface5,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          row(
            '${context.tr.items} (${totals.itemCount})',
            (totals.itemsTotal).formatMoney(),
          ),
          if (totals.discount > 0) ...[
            row(
              context.tr.discount,
              '-${(totals.discount).formatMoney()}',
              color: context.appColors.error,
            ),
          ],
          row(context.tr.subtotal, (totals.subtotal).formatMoney()),
          row(
            '${context.tr.tax} (${(flags.taxRate * 100).toStringAsFixed(0)}%)',
            (totals.tax).formatMoney(),
          ),
          row(
            context.tr.delivery,
            totals.delivery == 0
                ? context.tr.free
                : (totals.delivery).formatMoney(),
            color: totals.delivery == 0 ? context.textColors.main : null,
          ),
          const Divider(height: 20),
          row(context.tr.total, (totals.total).formatMoney(), bold: true),
          if (totals.delivery > 0) ...[
            getSpaceHeight(context, 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(value: progress, minHeight: 6),
            ),

            getSpaceHeight(context, 8),
            AppText(
              context.tr.addMoreForFreeDelivery(totals.freeDeliveryRemaining),
              fontSize: 12,
              color: context.appColors.surface5,
            ),
          ],
        ],
      ),
    );
  }
}
