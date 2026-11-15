import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  static final NumberFormat _inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrPreciseFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Converts an amount in paise (1 INR = 100 paise) to a formatted rupee string.
  /// Example: 2456000 paise -> "₹24,560"
  static String formatPaise(int paise, {bool showDecimals = false}) {
    final double rupees = paise / 100.0;
    if (showDecimals || paise % 100 != 0) {
      return _inrPreciseFormat.format(rupees);
    }
    return _inrFormat.format(rupees);
  }

  /// Parses a string into paise integer.
  /// Example: "450.50" -> 45050
  static int parseToPaise(String amountStr) {
    final cleaned = amountStr.replaceAll(RegExp(r'[^0-9.]'), '');
    final double val = double.tryParse(cleaned) ?? 0.0;
    return (val * 100).round();
  }
}
