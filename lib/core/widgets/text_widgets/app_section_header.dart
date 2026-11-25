import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

import 'app_text.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final IconData? icon;
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 6),
        ],
        AppText(title, fontSize: 16, fontWeight: FontWeight.bold),
        const Spacer(),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: AppText(
              actionText!,
              fontSize: 12,
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
