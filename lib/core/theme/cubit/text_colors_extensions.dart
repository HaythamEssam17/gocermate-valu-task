import 'package:material_ui/material_ui.dart';

@immutable
class TextColorsExtension extends ThemeExtension<TextColorsExtension> {
  final Color white;
  final Color textDisabled;
  final Color textHint;
  final Color lightText;
  final Color main;
  final Color black;

  const TextColorsExtension({
    required this.white,
    required this.textDisabled,
    required this.textHint,
    required this.lightText,
    required this.main,
    required this.black,
  });

  static const light = TextColorsExtension(
    white: Colors.white,
    textDisabled: Color(0xFFCBD5E1),
    textHint: Color(0xFF94A3B8),
    lightText: Color(0xFF64748B),
    main: Color(0xFF1E293B),
    black: Colors.black,
  );

  static const dark = TextColorsExtension(
    white: Color(0xff101F29),
    black: Colors.white,
    main: Color(0xffF1F5F9),
    lightText: Color(0xff94A3B8),
    textDisabled: Color(0xff94A3B8),
    textHint: Color(0xFF64748B),
  );

  @override
  TextColorsExtension copyWith({
    Color? white,
    Color? textDisabled,
    Color? textHint,
    Color? light,
    Color? main,
    Color? black,
  }) {
    return TextColorsExtension(
      white: white ?? this.white,
      textDisabled: textDisabled ?? this.textDisabled,
      textHint: textHint ?? this.textHint,
      lightText: light ?? lightText,
      main: main ?? this.main,
      black: black ?? this.black,
    );
  }

  @override
  TextColorsExtension lerp(
    ThemeExtension<TextColorsExtension>? other,
    double t,
  ) {
    if (other is! TextColorsExtension) return this;
    return TextColorsExtension(
      white: Color.lerp(white, other.white, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      lightText: Color.lerp(lightText, other.lightText, t)!,
      main: Color.lerp(main, other.main, t)!,
      black: Color.lerp(black, other.black, t)!,
    );
  }
}
