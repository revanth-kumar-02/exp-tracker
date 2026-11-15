import '../domain/notification_payload.dart';
import '../domain/parsed_transaction.dart';
import 'parser_utils.dart';
import 'transaction_parser.dart';

class SliceParser implements TransactionParser {
  @override
  String get parserName => 'Slice Card Parser';

  @override
  bool canHandle(NotificationPayload payload) {
    final pkg = payload.packageName.toLowerCase();
    final content = payload.fullContent.toLowerCase();
    return pkg.contains('slice') || content.contains('slice');
  }

  @override
  ParsedTransaction? parse(NotificationPayload payload) {
    final text = payload.fullContent;
    if (ParserUtils.isNonTransaction(text)) return null;

    final amount = ParserUtils.extractAmountPaise(text);
    if (amount == null || amount <= 0) return null;

    final cardSuffix = ParserUtils.extractCardSuffix(text);
    final merchant = ParserUtils.extractMerchant(text, defaultName: 'Slice Transaction');
    final type = ParserUtils.determineType(text);

    return ParsedTransaction(
      amountPaise: amount,
      merchant: merchant,
      cardSuffix: cardSuffix,
      type: type,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(payload.postTime),
      rawText: text,
      sourceApp: payload.packageName.isNotEmpty ? payload.packageName : 'indwin.c3.shareSpend',
    );
  }
}
