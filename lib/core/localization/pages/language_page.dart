import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/localization/cubit/locale_cubit.dart';
import 'package:grocermate/core/localization/widgets/lang_tile.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:material_ui/material_ui.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: context.tr.lblLanguage,
      showBackButton: true,
      body: AppCard(
        child: Column(
          children: [
            LangTile(
              flag: '🇪🇬',
              title: 'العربية',
              subtitle: context.tr.lblDefault,
              isSelected:
                  context.read<LocaleCubit>().state.languageCode == 'ar',
              onTap: () {
                context.read<LocaleCubit>().setLocale(const Locale('ar'));
              },
            ),
            Divider(height: 16, color: context.appColors.divider),
            LangTile(
              flag: '🇺🇸',
              title: 'English',
              subtitle: 'English',
              isSelected:
                  context.read<LocaleCubit>().state.languageCode == 'en',
              onTap: () {
                context.read<LocaleCubit>().setLocale(const Locale('en'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
