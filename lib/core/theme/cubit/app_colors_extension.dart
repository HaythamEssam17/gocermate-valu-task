import 'package:material_ui/material_ui.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color black;
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryBg;
  final Color primaryBgDark;
  final Color background;
  final Color card;
  final Color cardElevated;
  final Color white;
  final Color border;
  final Color divider;
  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;
  final Color error;
  final Color errorBg;
  final Color info;
  final Color infoBg;
  final Color disabled;
  final Color active;
  final Color darkBackground;
  final Color surface6;
  final Color surface5;
  final Color blue;
  final Color darkPurple;
  final Color lightPurple;

  const AppColorsExtension({
    required this.black,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryBg,
    required this.primaryBgDark,
    required this.background,
    required this.card,
    required this.cardElevated,
    required this.white,
    required this.border,
    required this.divider,
    required this.success,
    required this.successBg,
    required this.warning,
    required this.warningBg,
    required this.error,
    required this.errorBg,
    required this.info,
    required this.infoBg,
    required this.disabled,
    required this.active,
    required this.darkBackground,
    required this.surface6,
    required this.surface5,
    required this.blue,
    required this.darkPurple,
    required this.lightPurple,
  });

  static const light = AppColorsExtension(
    black: Colors.black,
    primary: Color(0xffFF4500),
    primaryDark: Color(0xffE63E00),
    primaryLight: Color(0xffFF6A33),
    primaryBg: Color(0xffFFF0EB),
    primaryBgDark: Color(0xff2A1A14),
    background: Color(0xffF5F7FA),
    card: Color(0xffffffff),
    cardElevated: Color(0xffF7F9FC),
    white: Color(0xffffffff),
    border: Color(0xffE2E8F0),
    divider: Color(0xffE5E7EB),
    success: Color(0xff22C55E),
    successBg: Color(0xffDCFCE7),
    warning: Color(0xffD35400),
    warningBg: Color(0xffFEF3C7),
    error: Color(0xffE40606),
    errorBg: Color(0xffFBE9DD),
    info: Color(0xff0EA5E9),
    infoBg: Color(0xffE0F2FE),
    disabled: Color(0xffCBD5E1),
    active: Color(0xff1E1D1A),
    darkBackground: Color(0xff2A2926),
    surface6: Color(0xffE8E5DE),
    surface5: Color(0xffF5F4F0),
    blue: Color(0xff1E40AF),
    darkPurple: Color(0xff2E2844),
    lightPurple: Color(0xffcfc6fa),
  );

  static const dark = AppColorsExtension(
    black: Color(0xffF7F9FC),
    primary: Color(0xffFF4400),
    primaryDark: Color(0xffE63E00),
    primaryLight: Color(0xffFF6A33),
    primaryBg: Color(0xffFFF0EB),
    primaryBgDark: Color(0xff2A1A14),
    background: Color(0xff121417),
    card: Color(0xff1C1F26),
    cardElevated: Color(0xff242831),
    white: Color(0xff000000),
    border: Color(0xff2A2E39),
    divider: Color(0xff2A2E39),
    success: Color(0xff22C55E),
    successBg: Color(0xff132E1F),
    warning: Color(0xffaa7b56),
    warningBg: Color(0xff342F2C),
    error: Color(0xffE40606),
    errorBg: Color(0xff2A1515),
    info: Color(0xff0EA5E9),
    infoBg: Color(0xff1a3149),
    disabled: Color(0xff475569),
    active: Color(0xffF1F5F9),
    darkBackground: Color(0xff121417),
    surface6: Color(0xff2A2E39),
    surface5: Color(0xff1C1F26),
    blue: Color(0xff1E40AF),
    darkPurple: Color(0xff2E2844),
    lightPurple: Color(0xffC3B6FD),
  );

  @override
  AppColorsExtension copyWith({
    Color? black,
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? primaryBg,
    Color? primaryBgDark,
    Color? background,
    Color? card,
    Color? cardElevated,
    Color? white,
    Color? border,
    Color? divider,
    Color? success,
    Color? successBg,
    Color? warning,
    Color? warningBg,
    Color? error,
    Color? errorBg,
    Color? info,
    Color? infoBg,
    Color? disabled,
    Color? active,
    Color? darkBackground,
    Color? surface6,
    Color? surface5,
    Color? blue,
    Color? darkPurple,
    Color? lightPurple,
  }) {
    return AppColorsExtension(
      black: black ?? this.black,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryBg: primaryBg ?? this.primaryBg,
      primaryBgDark: primaryBgDark ?? this.primaryBgDark,
      background: background ?? this.background,
      card: card ?? this.card,
      cardElevated: cardElevated ?? this.cardElevated,
      white: white ?? this.white,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      error: error ?? this.error,
      errorBg: errorBg ?? this.errorBg,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
      disabled: disabled ?? this.disabled,
      active: active ?? this.active,
      darkBackground: darkBackground ?? this.darkBackground,
      surface6: surface6 ?? this.surface6,
      surface5: surface5 ?? this.surface5,
      blue: blue ?? this.blue,
      darkPurple: darkPurple ?? this.darkPurple,
      lightPurple: lightPurple ?? this.lightPurple,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      black: Color.lerp(black, other.black, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryBg: Color.lerp(primaryBg, other.primaryBg, t)!,
      primaryBgDark: Color.lerp(primaryBgDark, other.primaryBgDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardElevated: Color.lerp(cardElevated, other.cardElevated, t)!,
      white: Color.lerp(white, other.white, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      active: Color.lerp(active, other.active, t)!,
      darkBackground: Color.lerp(darkBackground, other.darkBackground, t)!,
      surface6: Color.lerp(surface6, other.surface6, t)!,
      surface5: Color.lerp(surface5, other.surface5, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      darkPurple: Color.lerp(darkPurple, other.darkPurple, t)!,
      lightPurple: Color.lerp(lightPurple, other.lightPurple, t)!,
    );
  }
}
