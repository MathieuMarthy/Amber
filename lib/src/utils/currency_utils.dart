import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyUtils {
  /// Determines if the currency symbol should be placed on the left.
  static bool isSymbolOnLeft(String symbol) {
    return symbol == '\$' || symbol == '£' || symbol == '¥' || symbol == 'CAD\$' || symbol == 'AUD\$';
  }

  /// Formats the price according to the currency symbol's preferred position
  /// while keeping the locale's decimal and grouping separators.
  static String format(BuildContext context, int priceInCents, String symbol) {
    final locale = Localizations.localeOf(context).toString();
    final isLeft = isSymbolOnLeft(symbol);
    final pattern = isLeft ? '\u00a4#,##0.00' : '#,##0.00 \u00a4';

    final customFormat = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      locale: locale,
      customPattern: pattern,
    );

    return customFormat.format(priceInCents / 100);
  }
}
