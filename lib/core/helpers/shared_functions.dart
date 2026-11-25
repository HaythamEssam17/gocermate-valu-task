import 'dart:developer' as developer;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';

void devLog(String message) {
  developer.log('developer log a custom message: $message');
}

SizedBox getSpaceHeight(BuildContext context, double height) {
  final double currentHeight = context.screenHeight * (height / 812);
  return SizedBox(height: currentHeight);
}

SizedBox getSpaceWidth(BuildContext context, double width) {
  final double currentWidth = context.screenWidth * (width / 375);
  return SizedBox(width: currentWidth);
}
