import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_events.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_states.dart';
import 'package:material_ui/material_ui.dart';

class ActiveFilters extends StatelessWidget {
  const ActiveFilters({super.key, required this.state});
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
