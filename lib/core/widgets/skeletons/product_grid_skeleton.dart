import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

import 'product_card_skeleton.dart';

SliverGridDelegate getProductGridDelegate(BuildContext context) {
  final crossAxisCount = context.responsiveValue<int>(
    mobile: 2,
    tablet: 3,
    desktop: 4,
  );
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    mainAxisExtent: 270,
  );
}

class SliverProductGridSkeleton extends StatelessWidget {
  const SliverProductGridSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        sliver: SliverGrid(
          gridDelegate: getProductGridDelegate(context),
          delegate: SliverChildBuilderDelegate(
            (_, _) => const ProductCardSkeleton(),
            childCount: count,
          ),
        ),
      );
}
