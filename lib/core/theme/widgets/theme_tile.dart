import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    child: Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            AppText(title, fontWeight: FontWeight.bold),
            const Spacer(),
            if (isSelected) ...[
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
    ),
  );
}
