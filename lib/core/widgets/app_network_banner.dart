import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import 'text_widgets/app_text.dart';

class AppNetworkBanner extends StatelessWidget {
  const AppNetworkBanner({super.key, required this.offline});
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textColors = context.textColors;

    final bg = offline ? colors.errorBg : colors.successBg;

    return Material(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                offline ? LucideIcons.wifiOff : LucideIcons.wifi,
                size: 18,
                color: colors.white,
              ),

              getSpaceWidth(context, 12),

              Expanded(
                child: AppText(
                  offline ? context.tr.youAreOffline : context.tr.backOnline,
                  color: textColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
