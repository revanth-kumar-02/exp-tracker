import '../domain/notification_payload.dart';
import '../domain/parsed_transaction.dart';
import 'parser_utils.dart';
import 'transaction_parser.dart';

class GenericParser implements TransactionParser {
  @override
  String get parserName => 'Generic Financial Parser';

  @override
  bool canHandle(NotificationPayload payload) {
    // Fallback for any notification containing financial amount markers
    final text = payload.fullContent.toLowerCase();
    return text.contains('inr') ||
        text.contains('rs.') ||
        text.contains('rs ') ||
        text.contains('₹') ||
        text.contains('debited') ||
        text.contains('spent') ||
        text.contains('paid');
  }

  @override
  ParsedTransaction? parse(NotificationPayload payload) {
    final text = payload.fullContent;
    if (ParserUtils.isNonTransaction(text)) return null;

    final amount = ParserUtils.extractAmountPaise(text);
    if (amount == null || amount <= 0) return null;

    final cardSuffix = ParserUtils.extractCardSuffix(text);
    final merchant = ParserUtils.extractMerchant(text, defaultName: 'Payment Transaction');
    final type = ParserUtils.determineType(text);

    return ParsedTransaction(
      amountPaise: amount,
      merchant: merchant,
      cardSuffix: cardSuffix,
      type: type,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(payload.postTime),
      rawText: text,
      sourceApp: payload.packageName.isNotEmpty ? payload.packageName : 'android.generic.notification',
    );
  }
}
