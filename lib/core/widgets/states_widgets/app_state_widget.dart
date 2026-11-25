import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/app_button_type.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:material_ui/material_ui.dart';

class AppStateWidget extends StatelessWidget {
  const AppStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: context.appColors.card,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38),
            ),
            getSpaceHeight(context, 16),
            AppText(
              title,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),

            if (message != null) ...[
              getSpaceHeight(context, 8),
              AppText(
                message!,
                textAlign: TextAlign.center,
                color: context.appColors.surface5,
                fontSize: 16,
              ),
            ],
            if (onAction != null) ...[
              getSpaceHeight(context, 16),
              AppButton(
                text: actionLabel ?? context.tr.lblRetry,
                onPressed: onAction,
                icon: actionIcon ?? Icons.refresh,
                type: AppButtonType.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
