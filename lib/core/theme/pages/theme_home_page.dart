import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/theme/cubit/theme_cubit.dart';
import 'package:grocermate/core/theme/widgets/theme_tile.dart';
import 'package:grocermate/core/utils/enums/app_theme_mode.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:material_ui/material_ui.dart';

class ThemeHomePage extends StatelessWidget {
  const ThemeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: context.tr.lblTheme,
      showBackButton: true,
      body: Column(
        children: [
          ThemeTile(
            title: context.tr.lblLightMode,
            isSelected: !context.read<ThemeCubit>().isDark,
            onTap: () {
              context.read<ThemeCubit>().setTheme(AppThemeMode.light);
            },
          ),
          getSpaceHeight(context, 16),

          ThemeTile(
            title: context.tr.lblDarkMode,
            isSelected: context.read<ThemeCubit>().isDark,
            onTap: () {
              context.read<ThemeCubit>().setTheme(AppThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}
