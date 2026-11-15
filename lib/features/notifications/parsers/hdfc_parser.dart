import '../domain/notification_payload.dart';
import '../domain/parsed_transaction.dart';
import 'parser_utils.dart';
import 'transaction_parser.dart';

class HdfcParser implements TransactionParser {
  @override
  String get parserName => 'HDFC Bank Parser';

  @override
  bool canHandle(NotificationPayload payload) {
    final pkg = payload.packageName.toLowerCase();
    final content = payload.fullContent.toLowerCase();
    return pkg.contains('hdfc') || content.contains('hdfc');
  }

  @override
  ParsedTransaction? parse(NotificationPayload payload) {
    final text = payload.fullContent;
    if (ParserUtils.isNonTransaction(text)) return null;

    final amount = ParserUtils.extractAmountPaise(text);
    if (amount == null || amount <= 0) return null;

    final cardSuffix = ParserUtils.extractCardSuffix(text);
    final merchant = ParserUtils.extractMerchant(text, defaultName: 'HDFC Transaction');
    final type = ParserUtils.determineType(text);

    return ParsedTransaction(
      amountPaise: amount,
      merchant: merchant,
      cardSuffix: cardSuffix,
      type: type,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(payload.postTime),
      rawText: text,
      sourceApp: payload.packageName.isNotEmpty ? payload.packageName : 'com.snapwork.hdfc',
    );
  }
}
