import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';

import 'loading_skeleton.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: LoadingSkeleton(height: double.infinity, radius: 16),
        ),
        getSpaceHeight(context, 12),
        const LoadingSkeleton(width: 110),
        getSpaceHeight(context, 6),
        const LoadingSkeleton(width: 70, height: 12),
        getSpaceHeight(context, 12),
        const LoadingSkeleton(width: 60, height: 18),
        getSpaceHeight(context, 6),
      ],
    );
  }
}
