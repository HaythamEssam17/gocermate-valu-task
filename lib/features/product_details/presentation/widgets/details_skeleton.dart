import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/widgets/skeletons/loading_skeleton.dart';
import 'package:material_ui/material_ui.dart';

class DetailsSkeleton extends StatelessWidget {
  const DetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LoadingSkeleton(height: 260, radius: 20, width: double.infinity),
        getSpaceHeight(context, 16),
        const LoadingSkeleton(width: 220, height: 22),
        getSpaceHeight(context, 16),
        const LoadingSkeleton(width: 120),
        getSpaceHeight(context, 16),
        const LoadingSkeleton(height: 60, width: double.infinity),
      ],
    ),
  );
}
