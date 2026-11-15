import '../domain/notification_payload.dart';
import '../domain/parsed_transaction.dart';
import 'amazon_pay_icici_parser.dart';
import 'axis_parser.dart';
import 'canara_parser.dart';
import 'generic_parser.dart';
import 'hdfc_parser.dart';
import 'icici_parser.dart';
import 'iob_parser.dart';
import 'rbl_parser.dart';
import 'sbi_parser.dart';
import 'slice_parser.dart';
import 'transaction_parser.dart';

class ParserRegistry {
  final List<TransactionParser> _parsers = [
    AmazonPayIciciParser(), // Specific co-branded ICICI before general ICICI
    HdfcParser(),
    SbiParser(),
    IciciParser(),
    AxisParser(),
    RblParser(),
    CanaraParser(),
    SliceParser(),
    IobParser(),
    GenericParser(), // Generic fallback is always evaluated last
  ];

  ParsedTransaction? parseNotification(NotificationPayload payload) {
    for (final parser in _parsers) {
      if (parser.canHandle(payload)) {
        final result = parser.parse(payload);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }
}
