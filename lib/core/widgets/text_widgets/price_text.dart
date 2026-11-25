import 'package:material_ui/material_ui.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.originalPrice,
    this.large = false,
  });
  final double price;
  final double? originalPrice;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 6,
      children: [
        AppText(
          price.formatMoney(),
          fontSize: large ? 24 : 16,
          fontWeight: FontWeight.w800,
          color: hasDiscount
              ? context.textColors.main
              : context.appColors.surface5,
        ),

        if (hasDiscount) ...[
          AppText(
            originalPrice!.formatMoney(),
            fontSize: large ? 15 : 12,
            decoration: TextDecoration.lineThrough,
            color: context.textColors.lightText,
          ),
        ],
      ],
    );
  }
}
