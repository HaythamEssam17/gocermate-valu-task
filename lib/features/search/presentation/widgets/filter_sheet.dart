import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/di/injection.dart';
import 'package:grocermate/core/factories/loading_factory.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/widgets/bottom_sheets/glass_bottom_sheet.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/brands/brands_cubit.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_events.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showFilterSheet(BuildContext context) {
  final searchBloc = context.read<SearchBloc>();
  final categoriesBloc = context.read<CategoriesBloc>();

  return showGlassBottomModalSheet(
    context: context,
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchBloc),
        BlocProvider.value(value: categoriesBloc),
        BlocProvider(
          create: (_) => sl<BrandsCubit>()..load(searchBloc.state.categoryId),
        ),
      ],
      child: const _FilterSheet(),
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _category = context.read<SearchBloc>().state.categoryId;
  late String? _brand = context.read<SearchBloc>().state.brand;

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoriesBloc>().state.categories;
    final brands = context.watch<BrandsCubit>().state;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: AppText(
                    'Filters',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppButton(
                  text: 'Reset',
                  onPressed: () => setState(() {
                    _category = null;
                    _brand = null;
                    context.read<BrandsCubit>().load(null);
                  }),
                  isFullWidth: false,
                ),
              ],
            ),
            getSpaceHeight(context, 8),
            const AppText('Category', fontWeight: FontWeight.w700),

            getSpaceHeight(context, 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final c in categories)
                  ChoiceChip(
                    label: AppText('${c.icon} ${c.name}'),
                    selected: _category == c.id,
                    onSelected: (sel) {
                      setState(() {
                        _category = sel ? c.id : null;
                        _brand = null;
                      });
                      context.read<BrandsCubit>().load(_category);
                    },
                  ),
              ],
            ),
            getSpaceHeight(context, 16),

            const AppText('Brand', fontWeight: FontWeight.w700),
            getSpaceHeight(context, 8),

            if (brands.status == ViewStatus.loading)
              PlatformLoading.buildLoading(context: context)
            else if (brands.status == ViewStatus.failure)
              const AppText('Brands are unavailable right now.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final b in brands.brands)
                    FilterChip(
                      label: AppText(b),
                      selected: _brand == b,
                      onSelected: (sel) =>
                          setState(() => _brand = sel ? b : null),
                    ),
                ],
              ),
            getSpaceHeight(context, 20),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Apply filters',
                onPressed: () {
                  context.read<SearchBloc>().add(
                    SearchFilterChanged(categoryId: _category, brand: _brand),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
