import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:grocermate/features/product_details/presentation/bloc/product_details_events.dart';
import 'package:grocermate/features/product_details/presentation/bloc/product_details_states.dart';
import 'package:grocermate/features/product_details/presentation/widgets/details_skeleton.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import 'product_details_content.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      padding: EdgeInsets.zero,
      title: 'Product Details',
      showBackButton: true,
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, s) {
          switch (s.status) {
            case ViewStatus.initial:
            case ViewStatus.loading:
              return const DetailsSkeleton();

            case ViewStatus.failure:
              return AppStateWidget(
                message: s.failure?.message ?? 'Could not load this product.',
                onAction: () => context.read<ProductDetailsBloc>().add(
                  ProductDetailsRequested(productId),
                ),
                icon: LucideIcons.databaseX,
                title: context.tr.lblRetry,
              );

            case ViewStatus.success:
              return ProductDetailsContent(state: s);
          }
        },
      ),
    );
  }
}
