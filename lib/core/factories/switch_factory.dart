import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

abstract class SwitchFactory {
  factory SwitchFactory(TargetPlatform platform) {
    if (platform == TargetPlatform.android) {
      return AndroidSwitch();
    }

    return IOSSwitch();
  }
  Widget buildSwitch({
    required BuildContext context,
    required bool value,
    required void Function(bool value) onChanged,
  });
}

class AndroidSwitch implements SwitchFactory {
  @override
  Widget buildSwitch({
    required BuildContext context,
    required bool value,
    required void Function(bool value) onChanged,
  }) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: context.appColors.background,
      activeTrackColor: context.appColors.success,
      inactiveThumbColor: context.appColors.background,
      inactiveTrackColor: context.appColors.divider,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.circle_rounded, color: context.appColors.background),
      ),
    );
  }
}

class IOSSwitch implements SwitchFactory {
  @override
  Widget buildSwitch({
    required BuildContext context,
    required bool value,
    required void Function(bool value) onChanged,
  }) {
    return CupertinoSwitch(value: value, onChanged: onChanged);
  }
}

/// Use This in UI
class PlatformSwitch {
  static Widget buildSwitch({
    required BuildContext context,
    required bool value,
    required void Function(bool value) onChanged,
  }) {
    return SwitchFactory(Theme.of(context).platform)
        .buildSwitch(context: context, value: value, onChanged: onChanged);
  }
}
