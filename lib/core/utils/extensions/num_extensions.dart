extension StringExtension on num {
  // String formatPrice(BuildContext context, {int decimalDigits = 0}) {
  //   final locale = Localizations.localeOf(context);
  //
  //   return NumberFormat.currency(
  //     locale: locale.languageCode,
  //     symbol: context.tr.lblEGP,
  //     decimalDigits: decimalDigits,
  //   ).format(this);
  // }

  double roundAmountToDouble() => (this * 100).roundToDouble() / 100;

  String formatMoney() => '\$${toStringAsFixed(2)}';
}
