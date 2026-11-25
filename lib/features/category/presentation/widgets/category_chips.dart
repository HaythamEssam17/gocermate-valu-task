import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/skeletons/loading_skeleton.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/category/presentation/bloc/category_event.dart';
import 'package:grocermate/features/category/presentation/bloc/category_states.dart';
import 'package:grocermate/features/products/presentation/bloc/products_bloc.dart';
import 'package:grocermate/features/products/presentation/bloc/products_events.dart';
import 'package:grocermate/features/products/presentation/bloc/products_states.dart';
import 'package:material_ui/material_ui.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state.status == ViewStatus.failure) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ActionChip(
                  avatar: const Icon(Icons.refresh, size: 18),
                  label: AppText(context.tr.failedToLoadCategories),
                  onPressed: () => context.read<CategoriesBloc>().add(
                    const CategoriesRequested(),
                  ),
                ),
              ),
            );
          }
          if (state.categories.isEmpty) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 5,
              separatorBuilder: (_, _) => getSpaceWidth(context, 8),
              itemBuilder: (_, _) =>
                  const LoadingSkeleton(width: 90, height: 36, radius: 18),
            );
          }
          return BlocSelector<ProductsBloc, ProductsState, String?>(
            selector: (s) => s.categoryId,
            builder: (context, selected) => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.categories.length + 1,
              separatorBuilder: (_, _) => getSpaceWidth(context, 8),
              itemBuilder: (context, i) {
                final cat = i == 0 ? null : state.categories[i - 1];
                return ChoiceChip(
                  label: AppText(
                    cat == null ? context.tr.all : '${cat.icon} ${cat.name}',
                  ),
                  selected: selected == cat?.id,
                  onSelected: (_) => context.read<ProductsBloc>().add(
                    ProductsCategorySelected(cat?.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
