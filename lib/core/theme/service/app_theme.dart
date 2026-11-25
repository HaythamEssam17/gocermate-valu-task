import 'package:material_ui/material_ui.dart';

import '../cubit/app_colors_extension.dart';
import '../cubit/text_colors_extensions.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsExtension.light.background,
    fontFamily: 'Tajawal',
    extensions: const [AppColorsExtension.light, TextColorsExtension.light],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsExtension.light.background,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColorsExtension.light.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColorsExtension.light.border),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsExtension.dark.background,
    fontFamily: 'Tajawal',
    extensions: const [AppColorsExtension.dark, TextColorsExtension.dark],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsExtension.dark.background,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColorsExtension.dark.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColorsExtension.dark.border),
      ),
    ),
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColorsExtension.light.primary,
      AppColorsExtension.light.primaryLight,
    ],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
}
