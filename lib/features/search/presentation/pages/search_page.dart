import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/skeletons/product_grid_skeleton.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/products/presentation/widgets/product_grid.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_events.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_states.dart';
import 'package:grocermate/features/search/presentation/widgets/filter_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) {
        context.read<SearchBloc>().add(const SearchLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _submit(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    context.read<SearchBloc>().add(SearchQueryChanged(text, immediate: true));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return CustomScaffold(
      customBottomBar: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: (v) => bloc.add(SearchQueryChanged(v)),
        onSubmitted: _submit,
        decoration: InputDecoration(
          hintText: 'Search groceries...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, v, _) => v.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      bloc.add(const SearchQueryChanged('', immediate: true));
                    },
                  ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      appBarActions: [
        BlocSelector<SearchBloc, SearchState, int>(
          selector: (s) => s.activeFilters,
          builder: (context, count) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Filters',
              onPressed: () => showFilterSheet(context),
              icon: Badge(
                isLabelVisible: count > 0,
                label: AppText('$count'),
                child: const Icon(Icons.tune_rounded),
              ),
            ),
          ),
        ),
      ],

      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, s) {
          if (s.isIdle) return _Idle(state: s, onPick: _submit);
          return CustomScrollView(
            controller: _scroll,
            slivers: [
              if (s.activeFilters > 0)
                SliverToBoxAdapter(child: _ActiveFilters(state: s)),
              if (s.suggestions.isNotEmpty && s.query.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: s.suggestions.length,
                      separatorBuilder: (_, _) => getSpaceWidth(context, 8),
                      itemBuilder: (_, i) => ActionChip(
                        avatar: const Icon(Icons.north_west_rounded, size: 16),
                        label: AppText(s.suggestions[i]),
                        onPressed: () => _submit(s.suggestions[i]),
                      ),
                    ),
                  ),
                ),
              if (s.fromCache && s.status == ViewStatus.success)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: AppText('Searching saved products', fontSize: 12),
                  ),
                ),

              ..._results(context, s),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _results(BuildContext context, SearchState s) {
    switch (s.status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const [SliverProductGridSkeleton(count: 4)];
      case ViewStatus.failure:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppStateWidget(
              message: s.failure?.message ?? 'Search failed.',
              onAction: () =>
                  context.read<SearchBloc>().add(const SearchRetry()),
              title: context.tr.lblRetry,
              icon: LucideIcons.databaseX,
            ),
          ),
        ];
      case ViewStatus.success:
        if (s.items.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: AppStateWidget(
                icon: LucideIcons.searchSlash,
                title: s.query.isEmpty
                    ? 'No products match your filters'
                    : 'No results for "${s.query}"',
                message: 'Check the spelling or try different filters.',
                actionLabel: s.activeFilters > 0 ? 'Clear filters' : null,
                onAction: s.activeFilters > 0
                    ? () => context.read<SearchBloc>().add(
                        const SearchFilterChanged(),
                      )
                    : null,
              ),
            ),
          ];
        }
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: AppText(
                '${s.total} results',
                color: context.textColors.lightText,
              ),
            ),
          ),
          SliverProductGrid(
            items: s.items,
            hasMore: s.hasMore,
            isLoadingMore: s.isLoadingMore,
            loadMoreFailure: s.loadMoreFailure,
            onRetryLoadMore: () =>
                context.read<SearchBloc>().add(const SearchLoadMore()),
          ),
        ];
    }
  }
}

class _ActiveFilters extends StatelessWidget {
  const _ActiveFilters({required this.state});
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final categories = context.read<CategoriesBloc>().state.categories;
    final catName = categories
        .where((c) => c.id == state.categoryId)
        .firstOrNull
        ?.name;
    final bloc = context.read<SearchBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        children: [
          if (state.categoryId != null)
            InputChip(
              label: AppText(catName ?? state.categoryId!),
              onDeleted: () =>
                  bloc.add(SearchFilterChanged(brand: state.brand)),
            ),
          if (state.brand != null)
            InputChip(
              label: AppText(state.brand!),
              onDeleted: () =>
                  bloc.add(SearchFilterChanged(categoryId: state.categoryId)),
            ),
        ],
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({required this.state, required this.onPick});
  final SearchState state;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    if (state.recents.isEmpty) {
      return const AppStateWidget(
        icon: Icons.manage_search_rounded,
        title: 'Find your groceries',
        message:
            'Search by product name or use filters for category and brand.',
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText(
                  'Recent searches',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppButton(
                text: 'Clear',
                onPressed: () => context.read<SearchBloc>().add(
                  const SearchRecentsCleared(),
                ),
                isFullWidth: false,
              ),
            ],
          ),
          for (final r in state.recents)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history_rounded),
              title: AppText(r),
              trailing: const Icon(Icons.north_west_rounded, size: 18),
              onTap: () => onPick(r),
            ),
        ],
      ),
    );
  }
}
