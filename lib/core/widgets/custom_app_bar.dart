import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/localization/cubit/locale_cubit.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import 'buttons/app_icon_button.dart';
import 'text_widgets/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showSearchBar;
  final String? searchHint;
  final VoidCallback? onSearchTap;
  final Widget? customBottomBar;
  final Widget? customTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = false,
    this.showSearchBar = false,
    this.searchHint,
    this.onSearchTap,
    this.customBottomBar,
    this.customTitle,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(showSearchBar ? kToolbarHeight * 2 : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.textColors;

    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: AppIconButton(
                icon: Icon(
                  context.read<LocaleCubit>().state.languageCode == 'ar'
                      ? LucideIcons.chevronRight
                      : LucideIcons.chevronLeft,
                  size: 20,
                  color: context.textColors.main,
                ),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            )
          : null,
      title:
          customTitle ??
          (title != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(title!, fontSize: 18, fontWeight: FontWeight.w800),
                    if (subtitle != null) ...[
                      getSpaceHeight(context, 4),
                      AppText(subtitle!, fontSize: 12, color: text.lightText),
                    ],
                  ],
                )
              : null),
      actions: actions,
      bottom: showSearchBar
          ? const PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // child:
                // customBottomBar ??
                // AppSearchBar(
                //   hint: searchHint ?? 'ابحث...',
                //   onTap: onSearchTap,
                // ),
              ),
            )
          : null,
    );
  }
}
