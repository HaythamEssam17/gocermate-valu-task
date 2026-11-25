import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/skeletons/product_grid_skeleton.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/features/catalog/presentation/widgets/stale_notice.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/category/presentation/bloc/category_event.dart';
import 'package:grocermate/features/products/presentation/bloc/products_bloc.dart';
import 'package:grocermate/features/products/presentation/bloc/products_events.dart';
import 'package:grocermate/features/products/presentation/bloc/products_states.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/config/flags_repository.dart';
import '../../../category/presentation/widgets/category_chips.dart';
import '../../../products/presentation/widgets/product_grid.dart';
import '../bloc/deals_cubit.dart';
import '../widgets/deals_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) {
        context.read<ProductsBloc>().add(const ProductsLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final products = context.read<ProductsBloc>();
    context.read<CategoriesBloc>().add(
      const CategoriesRequested(forceRefresh: true),
    );
    context.read<DealsCubit>().load(forceRefresh: true);
    context.read<FlagsRepository>().refresh();
    products.add(const ProductsRefreshed());
    await products.stream.firstWhere(
      (s) => !s.isRefreshing && s.status != ViewStatus.loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'GrocerMate',
      body: RefreshIndicator.adaptive(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: StaleNotice()),

            const SliverToBoxAdapter(child: DealsSection()),

            const SliverToBoxAdapter(child: CategoryChips()),

            BlocBuilder<ProductsBloc, ProductsState>(
              buildWhen: (p, c) =>
                  p.status != c.status ||
                  p.items != c.items ||
                  p.isLoadingMore != c.isLoadingMore ||
                  p.loadMoreFailure != c.loadMoreFailure ||
                  p.hasMore != c.hasMore,
              builder: (context, state) {
                switch (state.status) {
                  case ViewStatus.initial:
                  case ViewStatus.loading:
                    return const SliverProductGridSkeleton();

                  case ViewStatus.failure:
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppStateWidget(
                        message:
                            state.failure?.message ??
                            context.tr.failedToLoadProducts,
                        onAction: () => context.read<ProductsBloc>().add(
                          const ProductsRetry(),
                        ),
                        icon: LucideIcons.circleOff,
                        title: context.tr.lblWrongHappen,
                      ),
                    );

                  case ViewStatus.success:
                    if (state.items.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppStateWidget(
                          icon: LucideIcons.textSearch,
                          title: context.tr.noProducts,
                          message: context.tr.tryAnotherCategory,
                        ),
                      );
                    }
                    return SliverProductGrid(
                      items: state.items,
                      hasMore: state.hasMore,
                      isLoadingMore: state.isLoadingMore,
                      loadMoreFailure: state.loadMoreFailure,
                      onRetryLoadMore: () => context.read<ProductsBloc>().add(
                        const ProductsLoadMore(),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
