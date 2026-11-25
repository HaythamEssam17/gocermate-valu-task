import 'dart:ui';

import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

Future<dynamic> showGlassBottomModalSheet({
  required BuildContext context,
  required Widget child,
  String? textKey,
  TextStyle? textStyle,
  void Function(dynamic value)? callBack,
}) async {
  final result = await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: context.appColors.white.withValues(alpha: 0.1),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: context.appColors.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: context.appColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        getSpaceHeight(context, 16),

                        if (textKey != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.responsiveValue<double>(
                                mobile: 16,
                                tablet: 24,
                                desktop: 32,
                              ),
                              vertical: 8,
                            ),
                            child: AppText(textKey),
                          ),
                        Flexible(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  if (callBack != null) {
    callBack(result);
  }
  return result;
}
