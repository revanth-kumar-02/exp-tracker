import '../domain/notification_payload.dart';
import '../domain/parsed_transaction.dart';

abstract class TransactionParser {
  /// Unique identifier of the parser
  String get parserName;

  /// Returns true if this parser can handle the notification
  bool canHandle(NotificationPayload payload);

  /// Attempts to parse the notification. Returns null if not a valid financial transaction.
  ParsedTransaction? parse(NotificationPayload payload);
}
