import 'package:grocermate/core/responsive/responsive.dart';
import 'package:grocermate/core/theme/cubit/app_colors_extension.dart';
import 'package:grocermate/core/theme/cubit/text_colors_extensions.dart';
import 'package:grocermate/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

extension AppThemeX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
  TextColorsExtension get textColors =>
      Theme.of(this).extension<TextColorsExtension>()!;

  AppLocalizations get tr => AppLocalizations.of(this)!;

  String get locale => Localizations.localeOf(this).languageCode;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isMobile => screenWidth < Breakpoints.mobileMax;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobileMax &&
      screenWidth < Breakpoints.tabletMax;
  bool get isDesktop => screenWidth >= Breakpoints.tabletMax;

  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  double scale() {
    final w = screenWidth;
    if (w < Breakpoints.mobileMax) {
      return (w / Breakpoints.standardWidth).clamp(0.85, 1.10);
    } else if (w < Breakpoints.tabletBreakpoint) {
      return 1.15;
    } else {
      return 1.25;
    }
  }

  double fontSize(double baseSize) {
    final s = scale();
    return (baseSize * s).clamp(baseSize * 0.85, baseSize * 1.40);
  }
}
