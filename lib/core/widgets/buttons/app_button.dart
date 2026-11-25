import 'package:grocermate/core/utils/enums/app_button_type.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double fontSize;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 48,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textColors = context.textColors;
    Color bg, fg, borderColor;

    switch (type) {
      case AppButtonType.primary:
        bg = colors.primary;
        fg = Colors.white;
        borderColor = Colors.transparent;
        break;
      case AppButtonType.secondary:
        bg = colors.cardElevated;
        fg = textColors.main;
        borderColor = Colors.transparent;
        break;
      case AppButtonType.outline:
        bg = Colors.transparent;
        fg = textColors.main;
        borderColor = colors.border;
        break;
      case AppButtonType.ghost:
        bg = Colors.transparent;
        fg = textColors.lightText;
        borderColor = Colors.transparent;
        break;
      case AppButtonType.danger:
        bg = colors.error;
        fg = Colors.white;
        borderColor = Colors.transparent;
        break;
    }

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              AppText(
                text,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: fg,
              ),
              if (icon != null) ...[Icon(icon, size: 16, color: fg)],
            ],
          );

    final button = Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(mobile: 16),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        gradient: type == AppButtonType.primary
            ? LinearGradient(colors: [colors.primary, colors.primaryDark])
            : null,
        boxShadow: type == AppButtonType.primary
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(child: child),
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
