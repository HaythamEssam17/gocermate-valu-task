import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

class LangTile extends StatelessWidget {
  final String flag, title, subtitle;
  final bool isSelected;
  final Function()? onTap;

  const LangTile({
    super.key,
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Material(
      color: Colors.transparent,
      child: Row(
        children: [
          AppText(flag, fontSize: 28),
          getSpaceWidth(context, 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(title, fontWeight: FontWeight.bold),
              AppText(
                subtitle,
                fontSize: 10,
                color: context.textColors.lightText,
              ),
            ],
          ),

          if (isSelected) ...[
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: context.appColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 14,
                color: context.appColors.white,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
