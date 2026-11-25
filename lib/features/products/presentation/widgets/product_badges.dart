import 'package:material_ui/material_ui.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.bg, this.fg);
  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: AppText(text, color: fg, fontSize: 11, fontWeight: FontWeight.w700),
  );
}

class ProductBadges extends StatelessWidget {
  const ProductBadges(this.product, {super.key});
  final ProductEntity product;

  static const _labels = {
    'fresh': 'Fresh',
    'protein': 'Protein',
    'vitaminC': 'Vitamin C',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pills = <Widget>[];
    if (product.hasDiscount) {
      pills.add(
        _Pill(
          '-${product.discountPercent}%',
          context.appColors.error,
          context.appColors.white,
        ),
      );
    }
    if (product.isLowStock) {
      pills.add(_Pill('Few left', context.appColors.warning, Colors.black87));
    } else {
      final info = product.badges.where(_labels.containsKey).firstOrNull;
      if (info != null) {
        pills.add(
          _Pill(
            _labels[info]!,
            scheme.primaryContainer,
            scheme.onPrimaryContainer,
          ),
        );
      }
    }
    if (pills.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 4, runSpacing: 4, children: pills);
  }
}
