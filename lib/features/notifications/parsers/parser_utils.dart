import '../domain/parsed_transaction.dart';

abstract class ParserUtils {
  // Non-transaction blacklist keywords (OTP, alerts, promos)
  static final List<RegExp> nonTransactionPatterns = [
    RegExp(r'\b(otp|one time password|secret code|verification code)\b', caseSensitive: false),
    RegExp(r'\b(login alert|password changed|logged in|security alert)\b', caseSensitive: false),
    RegExp(r'\b(pre-approved|apply now|claim your|congratulations)\b', caseSensitive: false),
    RegExp(r'\b(statement generated|bill is generated|due on)\b', caseSensitive: false),
  ];

  static bool isNonTransaction(String text) {
    for (final pattern in nonTransactionPatterns) {
      if (pattern.hasMatch(text)) return true;
    }
    return false;
  }

  /// Extracts amount in paise from text
  static int? extractAmountPaise(String text) {
    final match = RegExp(
      r'(?:INR|Rs\.?|₹)\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ).firstMatch(text);

    if (match != null) {
      final clean = match.group(1)!.replaceAll(',', '');
      final double? val = double.tryParse(clean);
      if (val != null) {
        return (val * 100).round();
      }
    }
    return null;
  }

  /// Extracts last 4 digits of payment card or account
  static String? extractCardSuffix(String text) {
    final patterns = [
      RegExp(r'(?:card|acct|a/c|ending in|ending with|ending|xx|\*\*)\s*(?:no\.?)?\s*(?:x+|\*+|\.\.+)?\s*(\d{4})\b', caseSensitive: false),
      RegExp(r'\b(\d{4})\s*(?:debited|credited|spent)', caseSensitive: false),
      RegExp(r'(?:••|xx|\*\*)\s*(\d{4})\b', caseSensitive: false),
    ];

    for (final regex in patterns) {
      final match = regex.firstMatch(text);
      if (match != null && match.group(1) != null) {
        return match.group(1);
      }
    }
    return null;
  }

  /// Extracts merchant name
  static String extractMerchant(String text, {String defaultName = 'Unknown Merchant'}) {
    final patterns = [
      RegExp(r'(?:at|to|info:)\s+([A-Za-z0-9&_\s\-.]{2,40}?)(?:\s+on\b|\s+for\b|\s+from\b|\s+using\b|\.|$)', caseSensitive: false),
      RegExp(r'(?:at\s+)([A-Za-z0-9&_\s\-.]{2,30})', caseSensitive: false),
      RegExp(r'(?:VPA\s+)([A-Za-z0-9&_@.-]+)', caseSensitive: false),
    ];

    for (final regex in patterns) {
      final match = regex.firstMatch(text);
      if (match != null && match.group(1) != null) {
        final raw = match.group(1)!.trim();
        if (raw.isNotEmpty && raw.length > 1) {
          // Clean trailing common punctuation/words
          final clean = raw.replaceAll(RegExp(r'(\s+on|\s+for|\s+via|\.)$', caseSensitive: false), '').trim();
          if (clean.isNotEmpty) return clean;
        }
      }
    }
    return defaultName;
  }

  /// Determines transaction type from content
  static ParsedTransactionType determineType(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('refund') || lower.contains('credited back')) {
      return ParsedTransactionType.refund;
    }
    if (lower.contains('reversed') || lower.contains('reversal')) {
      return ParsedTransactionType.reversal;
    }
    if (lower.contains('failed') || lower.contains('declined') || lower.contains('unsuccessful')) {
      return ParsedTransactionType.failed;
    }
    if (lower.contains('pre-auth') || lower.contains('authorized') || lower.contains('hold on')) {
      return ParsedTransactionType.pending;
    }
    if (lower.contains('credited') || lower.contains('deposited') || lower.contains('salary')) {
      return ParsedTransactionType.credit;
    }

    // Default financial debit
    return ParsedTransactionType.debit;
  }
}
