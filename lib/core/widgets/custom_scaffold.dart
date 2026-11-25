import 'package:grocermate/core/responsive/responsive_container.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

import 'custom_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showSearchBar;
  final String? searchHint;
  final VoidCallback? onSearchTap;
  final Widget? bottomNavigationBar;
  final bool isLoading;
  final Widget? customBottomBar;

  /// Layout configuration
  final bool useSafeArea;
  final bool isResponsive;
  final double maxResponsiveWidth;
  final EdgeInsetsGeometry? padding;

  const CustomScaffold({
    super.key,
    this.title,
    this.subtitle,
    required this.body,
    this.appBarActions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.showSearchBar = false,
    this.searchHint,
    this.onSearchTap,
    this.bottomNavigationBar,
    this.isLoading = false,
    this.useSafeArea = true,
    this.isResponsive = true,
    this.maxResponsiveWidth = 1200,
    this.padding,
    this.customBottomBar,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: context.responsiveValue<double>(
            mobile: 16,
            tablet: 24,
            desktop: 32,
          ),
          vertical: 16,
        );

    Widget content = isLoading
        ? Center(
            child: CircularProgressIndicator(color: context.appColors.primary),
          )
        : body;

    if (isResponsive) {
      content = ResponsiveContainer(
        maxWidth: maxResponsiveWidth,
        padding: responsivePadding,
        child: content,
      );
    }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: (title != null || appBarActions != null || showBackButton)
          ? CustomAppBar(
              title: title,
              subtitle: subtitle,
              actions: appBarActions,
              showBackButton: showBackButton,
              showSearchBar: showSearchBar,
              searchHint: searchHint,
              onSearchTap: onSearchTap,
              customBottomBar: customBottomBar,
            )
          : null,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
