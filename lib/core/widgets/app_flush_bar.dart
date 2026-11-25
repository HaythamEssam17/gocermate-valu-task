import 'package:another_flushbar/flushbar.dart';
import 'package:grocermate/core/utils/enums/flushbar_type.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:material_ui/material_ui.dart';

class AppFlushbar {
  AppFlushbar._();

  static Flushbar<dynamic>? _activeFlushbar;

  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    FlushbarType type = FlushbarType.info,
    FlushbarPosition position = FlushbarPosition.TOP,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool replaceExisting = true,
    Color? backgroundColor,
    IconData? icon,
    Widget? mainButton,
  }) async {
    final style = _styleForType(context, type);

    // if (!context.mounted) return;

    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    if (replaceExisting && _activeFlushbar != null) {
      await dismiss();
    }

    final flushbar = Flushbar<dynamic>(
      title: title,
      message: trimmedMessage,
      icon: Icon(icon ?? style.icon, color: Colors.white, size: 24),
      duration: duration,
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: backgroundColor ?? style.color,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDismissible: isDismissible,
      dismissDirection: position == FlushbarPosition.TOP
          ? FlushbarDismissDirection.VERTICAL
          : FlushbarDismissDirection.HORIZONTAL,
      mainButton: mainButton,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.16),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          _activeFlushbar = null;
        }
      },
    );

    _activeFlushbar = flushbar;

    if (context.mounted) {
      await flushbar.show(context);
    }
  }

  static Future<void> success(
    BuildContext context,
    String message, {
    String? title = 'نجاح',
    FlushbarPosition position = FlushbarPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: FlushbarType.success,
      position: position,
      duration: duration,
    );
  }

  static Future<void> error(
    BuildContext context,
    String message, {
    String? title = 'خطأ',
    FlushbarPosition position = FlushbarPosition.TOP,
    Duration duration = const Duration(seconds: 4),
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: FlushbarType.error,
      position: position,
      duration: duration,
    );
  }

  static Future<void> warning(
    BuildContext context,
    String message, {
    String? title = 'تنبيه',
    FlushbarPosition position = FlushbarPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: FlushbarType.warning,
      position: position,
      duration: duration,
    );
  }

  static Future<void> info(
    BuildContext context,
    String message, {
    String? title,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
    String? buttonText,
    Function()? onAction,
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: FlushbarType.info,
      position: position,
      duration: duration,
      mainButton: AppButton(text: buttonText!, onPressed: onAction),
    );
  }

  /// إخفاء الـ Flushbar الحالي إن وجد
  static Future<void> dismiss() async {
    final current = _activeFlushbar;
    _activeFlushbar = null;
    if (current != null && !current.isDismissed()) {
      await current.dismiss();
    }
  }

  static _FlushbarStyle _styleForType(BuildContext context, FlushbarType type) {
    switch (type) {
      case FlushbarType.success:
        return _FlushbarStyle(
          color: context.appColors.success,
          icon: Icons.check_circle_rounded,
        );
      case FlushbarType.error:
        return _FlushbarStyle(
          color: context.appColors.error,
          icon: Icons.error_rounded,
        );
      case FlushbarType.warning:
        return _FlushbarStyle(
          color: context.appColors.warning,
          icon: Icons.warning_amber_rounded,
        );
      case FlushbarType.info:
        return _FlushbarStyle(
          color: context.appColors.darkBackground,
          icon: Icons.info_rounded,
        );
    }
  }
}

class _FlushbarStyle {
  final Color color;
  final IconData icon;

  const _FlushbarStyle({required this.color, required this.icon});
}
