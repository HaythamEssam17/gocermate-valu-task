import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/app_button_type.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class InlineError extends StatelessWidget {
  const InlineError({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.bookX, color: scheme.onErrorContainer, size: 20),
          getSpaceWidth(context, 8),

          Expanded(child: AppText(message, color: context.appColors.error)),

          AppButton(
            text: context.tr.lblRetry,
            onPressed: onRetry,
            type: AppButtonType.ghost,
          ),
        ],
      ),
    );
  }
}
