import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

abstract class CheckboxFactory {
  factory CheckboxFactory(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return IOSCheckbox();
      case TargetPlatform.android:
        return AndroidCheckbox();
      default:
        return AndroidCheckbox();
    }
  }
  Widget buildCheckbox({
    required BuildContext context,
    required bool value,
    required Function(bool?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  });
}

class AndroidCheckbox implements CheckboxFactory {
  @override
  Widget buildCheckbox({
    required BuildContext context,
    required bool value,
    required Function(bool?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return InkWell(
      onTap: isEnabled ? () => onChanged(!value) : null,
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: isEnabled ? onChanged : null,
            activeColor: context.appColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  color: isEnabled ? null : context.textColors.lightText,
                ),
                if (subtitle != null)
                  AppText(
                    subtitle,
                    fontSize: 12,
                    color: context.textColors.textHint,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IOSCheckbox implements CheckboxFactory {
  @override
  Widget buildCheckbox({
    required BuildContext context,
    required bool value,
    required Function(bool?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: isEnabled ? () => onChanged(!value) : null,
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? (isEnabled
                            ? context.appColors.primary
                            : context.appColors.divider)
                      : context.appColors.divider,
                  width: 2,
                ),
                color: value
                    ? (isEnabled
                          ? context.appColors.primary
                          : context.appColors.divider)
                    : Colors.transparent,
              ),
              child: value
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    label,
                    color: isEnabled ? null : context.textColors.lightText,
                  ),
                  if (subtitle != null)
                    AppText(
                      subtitle,
                      fontSize: 12,
                      color: context.textColors.textHint,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlatformCheckbox {
  static Widget buildCheckbox({
    required BuildContext context,
    required bool value,
    required Function(bool?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return CheckboxFactory(Theme.of(context).platform).buildCheckbox(
      context: context,
      value: value,
      onChanged: onChanged,
      label: label,
      subtitle: subtitle,
      isEnabled: isEnabled,
    );
  }
}
