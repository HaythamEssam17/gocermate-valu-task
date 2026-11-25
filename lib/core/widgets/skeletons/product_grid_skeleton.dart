import 'package:material_ui/material_ui.dart';

import 'product_card_skeleton.dart';

const productGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  mainAxisExtent: 270,
);

class SliverProductGridSkeleton extends StatelessWidget {
  const SliverProductGridSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    sliver: SliverGrid(
      gridDelegate: productGridDelegate,
      delegate: SliverChildBuilderDelegate(
        (_, _) => const ProductCardSkeleton(),
        childCount: count,
      ),
    ),
  );
}
