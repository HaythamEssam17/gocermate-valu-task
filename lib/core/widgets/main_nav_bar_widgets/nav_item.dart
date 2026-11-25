import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textColors = context.textColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? colors.primaryBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isActive ? colors.primary : textColors.lightText,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: colors.primary,
                      child: Center(
                        child: AppText(
                          badgeCount > 9 ? '9+' : badgeCount.toString(),
                          color: context.textColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            getSpaceHeight(context, 4),
            AppText(
              label,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
              color: isActive ? colors.primary : textColors.lightText,
            ),
          ],
        ),
      ),
    );
  }
}
