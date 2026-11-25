import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    this.compact = false,
  });

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 28.0 : 34.0;

    Widget btn(IconData icon, VoidCallback onTap) => InkResponse(
          onTap: onTap,
          radius: size / 1.5,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: compact ? 18 : 20),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(qty <= 1 ? LucideIcons.trash : LucideIcons.minusCircle, onMinus),
          SizedBox(
            width: compact ? 22 : 28,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: AppText(
                '$qty',
                key: ValueKey<int>(qty),
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          btn(LucideIcons.circlePlus, onPlus),
        ],
      ),
    );
  }
}
