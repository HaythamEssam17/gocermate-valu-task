import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/app_theme_mode.dart';

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.light);

  void toggleTheme() {
    emit(state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light);
  }

  void setTheme(AppThemeMode mode) => emit(mode);

  bool get isDark => state == AppThemeMode.dark;
}

class ThemeState {
  final AppThemeMode mode;
  const ThemeState(this.mode);
}
