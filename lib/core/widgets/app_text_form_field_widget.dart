import 'package:flutter/services.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

import 'text_widgets/app_text.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintKey;
  final String? labelKey;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color? textInputColor;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isSelected;
  final bool evaluation;
  final bool isObscureText;
  final bool isDigitOnly;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? onChanged;
  final dynamic Function(String)? onSubmitted;
  final dynamic Function()? onSaved;
  final Color? borderColor;
  final Color? labelHintStyle;
  final Color? labelErrorStyle;
  final List<TextInputFormatter>? inputFormatter;
  final bool isReadOnly;
  final TextInputAction? textInputAction;
  final TextAlign? labelHintTextAlign;
  final double? radius;
  final bool? alignMultipleLines;
  final FocusNode? fieldFocusNode;
  final double? blurRadius;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final double hintFontSize;
  final Color? focuseAndErrorColor;
  final List<String>? autofillHints;

  const AppTextFormField({
    super.key,
    this.hintKey,
    this.labelKey,
    this.controller,
    this.keyboardType = TextInputType.name,
    this.onTap,
    this.enabled = true,
    this.isSelected = false,
    this.isObscureText = false,
    this.evaluation = true,
    this.isDigitOnly = false,
    this.minLines = 1,
    this.maxLines = 4,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.borderColor,
    this.textInputColor,
    this.labelHintStyle,
    this.labelErrorStyle,
    this.inputFormatter,
    this.isReadOnly = false,
    this.textInputAction = TextInputAction.next,
    this.labelHintTextAlign = TextAlign.start,
    this.radius = 8,
    this.alignMultipleLines = false,
    this.fieldFocusNode,
    this.blurRadius = 40,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 8),
    this.contentPaddingHorizontal = 12,
    this.contentPaddingVertical = 14.0,
    this.hintFontSize = 14,
    this.focuseAndErrorColor,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    final Color brColor = context.appColors.border;
    final Color fillBGColor = context.appColors.card;

    return TextFormField(
      onTap:
          onTap ??
          () {
            controller!.selection = TextSelection.fromPosition(
              TextPosition(offset: controller!.text.length),
            );
          },
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enabled,
      onEditingComplete: onSaved,
      keyboardType: keyboardType,
      obscureText: isObscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      readOnly: isReadOnly,
      textAlign: labelHintTextAlign!,
      focusNode: fieldFocusNode,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
        color: context.textColors.main,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      inputFormatters: inputFormatter,
      validator: validator,
      cursorColor: context.appColors.black,
      decoration: InputDecoration(
        hintText: hintKey,
        label: AppText(labelKey ?? hintKey ?? ''),
        hintStyle: Theme.of(context).textTheme.titleMedium!
            .copyWith(
              fontSize: hintFontSize,
              color: context.textColors.lightText,
            )
            .apply(color: labelHintStyle),
        alignLabelWithHint: alignMultipleLines,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(
            color: focuseAndErrorColor ?? brColor,
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(color: focuseAndErrorColor ?? brColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Color(0xff687BB1)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Color(0xff687BB1)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
          borderSide: BorderSide(
            color: focuseAndErrorColor ?? context.appColors.error,
            width: 0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
          borderSide: BorderSide(
            color: focuseAndErrorColor ?? context.appColors.error,
          ),
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          height: 0.5,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.fade,
        ).apply(color: labelErrorStyle),
        contentPadding: EdgeInsets.symmetric(
          vertical: contentPaddingVertical!,
          horizontal: contentPaddingHorizontal!,
        ),
        fillColor: isReadOnly ? context.appColors.disabled : fillBGColor,
        isDense: true,
        filled: true,
        prefixIcon: prefixIcon == null
            ? null
            : SizedBox(height: 24, width: 24, child: Center(child: prefixIcon)),
        labelStyle: Theme.of(context).textTheme.titleMedium!
            .copyWith(fontSize: 14, fontWeight: FontWeight.w500)
            .apply(color: context.appColors.card),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
