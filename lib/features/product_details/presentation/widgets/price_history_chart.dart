import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/utils/painters/price_history_painter.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

class PriceHistoryChart extends StatelessWidget {
  const PriceHistoryChart({super.key, required this.prices});
  final List<double> prices;

  @override
  Widget build(BuildContext context) {
    if (prices.length < 2) return const SizedBox.shrink();
    final min = prices.reduce((a, b) => a < b ? a : b);
    final max = prices.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 90,
          width: double.infinity,
          child: CustomPaint(
            painter: PriceHistoryPainter(
              prices,
              context.appColors.primary,
              context.appColors.success,
            ),
          ),
        ),
        getSpaceHeight(context, 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText('Low ${min.formatMoney()}', fontSize: 12),
            AppText('High ${max.formatMoney()}', fontSize: 12),
          ],
        ),
      ],
    );
  }
}
