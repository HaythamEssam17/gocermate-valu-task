import 'package:material_ui/material_ui.dart';

/// Screen size breakpoints
class Breakpoints {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
  static const double desktopMax = 1440;

  static const double standardWidth = 390;

  static const double mobileMaxHeight = 812;
  static const double tabletBreakpoint = 1024;
}

enum DeviceType { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.tabletMax && desktop != null) {
          return desktop!(context);
        }
        if (constraints.maxWidth >= Breakpoints.mobileMax && tablet != null) {
          return tablet!(context);
        }
        return mobile(context);
      },
    );
  }
}
