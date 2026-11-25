import 'package:grocermate/core/factories/loading_factory.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/skeletons/product_grid_skeleton.dart';
import 'package:grocermate/core/widgets/states_widgets/inline_error.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/error/failure.dart';
import '../../../products/presentation/widgets/product_card.dart';

class SliverProductGrid extends StatelessWidget {
  const SliverProductGrid({
    super.key,
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.loadMoreFailure,
    required this.onRetryLoadMore,
  });

  final List<ProductEntity> items;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final VoidCallback onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverGrid(
          gridDelegate: getProductGridDelegate(context),
          delegate: SliverChildBuilderDelegate(
            (_, i) =>
                ProductCard(key: ValueKey(items[i].id), product: items[i]),
            childCount: items.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _footer(context),
          ),
        ),
      ],
    );
  }

  Widget _footer(BuildContext context) {
    if (loadMoreFailure != null) {
      return InlineError(
        message: loadMoreFailure!.message,
        onRetry: onRetryLoadMore,
      );
    }
    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: PlatformLoading.buildLoading(context: context),
          ),
        ),
      );
    }
    if (!hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: AppText(
            context.tr.youReachedTheEnd,
            color: context.textColors.lightText,
          ),
        ),
      );
    }
    return getSpaceHeight(context, 40);
  }
}
