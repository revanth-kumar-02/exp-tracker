import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../cards/data/card_repository.dart';
import '../domain/notification_payload.dart';
import '../domain/parsed_transaction.dart';
import '../parsers/parser_registry.dart';
import 'deduplication_service.dart';

enum IngestionStatus {
  confirmed,
  unassigned,
  duplicate,
  ignoredNonFinancial,
}

class IngestionResult {
  final IngestionStatus status;
  final String? transactionId;
  final String? matchedCardId;
  final String? matchedCardName;
  final ParsedTransaction? parsedTransaction;

  const IngestionResult({
    required this.status,
    this.transactionId,
    this.matchedCardId,
    this.matchedCardName,
    this.parsedTransaction,
  });
}

final transactionIngestionServiceProvider = Provider<TransactionIngestionService>((ref) {
  final db = ref.watch(databaseProvider);
  final cardRepo = ref.watch(cardRepositoryProvider);
  return TransactionIngestionService(db, cardRepo, ParserRegistry());
});

class TransactionIngestionService {
  final AppDatabase _db;
  final CardRepository _cardRepo;
  final ParserRegistry _parserRegistry;

  TransactionIngestionService(this._db, this._cardRepo, this._parserRegistry);

  Future<IngestionResult> processNotification(NotificationPayload payload) async {
    // 1. Attempt parsing
    final parsed = _parserRegistry.parseNotification(payload);
    if (parsed == null) {
      return const IngestionResult(status: IngestionStatus.ignoredNonFinancial);
    }

    // 2. Compute deduplication fingerprint
    final fingerprint = DeduplicationService.generateFingerprint(parsed);

    // 3. Check for duplicates in DB
    final existing = await (_db.select(_db.transactions)
          ..where((tbl) => tbl.dedupeFingerprint.equals(fingerprint)))
        .getSingleOrNull();

    if (existing != null) {
      return IngestionResult(
        status: IngestionStatus.duplicate,
        transactionId: existing.id,
        parsedTransaction: parsed,
      );
    }

    // 4. Deterministic Last-Four Card Matching
    String? matchedCardId;
    String? matchedCardName;
    String matchStatus = 'UNASSIGNED';

    if (parsed.hasCardSuffix) {
      final card = await _cardRepo.findCardByLastFour(parsed.cardSuffix!);
      if (card != null) {
        matchedCardId = card.id;
        matchedCardName = '${card.bankName} ••${card.lastFour}';
        matchStatus = 'CONFIRMED';
      }
    }

    // 5. Persist to SQLite Database
    final txId = const Uuid().v4();
    await _db.into(_db.transactions).insert(
      TransactionsCompanion.insert(
        id: txId,
        paymentCardId: Value(matchedCardId),
        amountPaise: parsed.amountPaise,
        currency: const Value('INR'),
        merchant: parsed.merchant,
        description: Value(parsed.rawText),
        transactionType: Value(parsed.type.dbValue),
        matchStatus: Value(matchStatus),
        dedupeFingerprint: fingerprint,
        sourceApp: parsed.sourceApp,
        rawNotificationText: Value(parsed.rawText),
        occurredAt: parsed.occurredAt,
      ),
    );

    return IngestionResult(
      status: matchStatus == 'CONFIRMED'
          ? IngestionStatus.confirmed
          : IngestionStatus.unassigned,
      transactionId: txId,
      matchedCardId: matchedCardId,
      matchedCardName: matchedCardName,
      parsedTransaction: parsed,
    );
  }
}
