import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

abstract class RadioFactory<T> {
  factory RadioFactory(TargetPlatform platform) {
    if (TargetPlatform.iOS == platform) {
      return IOSRadio<T>();
    }

    return AndroidRadio<T>();
  }
  Widget buildRadio({
    required BuildContext context,
    required T value,
    required T groupValue,
    required T Function(T?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  });
}

class AndroidRadio<T> implements RadioFactory<T> {
  @override
  Widget buildRadio({
    required BuildContext context,
    required T value,
    required T groupValue,
    required T Function(T?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return InkWell(
      onTap: isEnabled ? () => onChanged(value) : null,
      child: Row(
        children: [
          RadioGroup<T>(
            groupValue: groupValue,
            onChanged: (val) {
              if (isEnabled) onChanged(val);
            },
            child: Radio<T>(
              value: value,
              enabled: isEnabled,
              activeColor: context.appColors.primary,
            ),
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

class IOSRadio<T> implements RadioFactory<T> {
  @override
  Widget buildRadio({
    required BuildContext context,
    required T value,
    required T groupValue,
    required T Function(T?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  }) {
    final isSelected = value == groupValue;

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 16),
      child: GestureDetector(
        onTap: isEnabled ? () => onChanged(value) : null,
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isEnabled
                            ? context.appColors.primary
                            : context.appColors.divider)
                      : context.appColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isEnabled
                              ? context.appColors.primary
                              : context.appColors.divider,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
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

class PlatformRadio {
  static Widget buildRadio<T>({
    required BuildContext context,
    required T value,
    required T groupValue,
    required T Function(T?) onChanged,
    required String label,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return RadioFactory<T>(Theme.of(context).platform).buildRadio(
      context: context,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      label: label,
      subtitle: subtitle,
      isEnabled: isEnabled,
    );
  }
}
