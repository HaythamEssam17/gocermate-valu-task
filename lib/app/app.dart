import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
import 'package:grocermate/core/localization/cubit/locale_cubit.dart';
import 'package:grocermate/core/router/app_router.dart';
import 'package:grocermate/core/theme/cubit/theme_cubit.dart';
import 'package:grocermate/core/theme/service/app_theme.dart';
import 'package:grocermate/core/utils/enums/app_theme_mode.dart';
import 'package:grocermate/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

import 'multi_bloc_provider_page.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

class GrocerMateApp extends StatelessWidget {
  const GrocerMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProviderPage(
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Grocer Mate',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
                locale: locale,
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: AppRoutes.router,
                builder: (context, child) => child!,
              );
            },
          );
        },
      ),
    );
  }
}
