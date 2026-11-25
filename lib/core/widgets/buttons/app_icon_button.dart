import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double size;
  final double radius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.size = 40,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.card,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor ?? colors.border),
        ),
        child: icon,
      ),
    );
  }
}
