import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../cards/data/card_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionRepository(db);
});

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  Stream<List<TransactionData>> watchTransactions({
    String? cardId,
    String? matchStatus,
    String? categoryId,
  }) {
    final query = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);

    if (cardId != null) {
      query.where((t) => t.paymentCardId.equals(cardId));
    }
    if (matchStatus != null) {
      query.where((t) => t.matchStatus.equals(matchStatus));
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }

    return query.watch();
  }

  Stream<int> watchUnassignedCount() {
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([_db.transactions.id.count()])
      ..where(_db.transactions.matchStatus.equals('UNASSIGNED'));

    return query.map((row) => row.read(_db.transactions.id.count()) ?? 0).watchSingle();
  }

  Future<void> assignCardAndCategory({
    required String transactionId,
    required String cardId,
    String? categoryId,
  }) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(transactionId))).write(
      TransactionsCompanion(
        paymentCardId: Value(cardId),
        categoryId: Value(categoryId),
        matchStatus: const Value('MANUAL'),
      ),
    );
  }

  Future<void> updateTransactionDetails({
    required String transactionId,
    required String merchant,
    String? categoryId,
    String? paymentCardId,
  }) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(transactionId))).write(
      TransactionsCompanion(
        merchant: Value(merchant),
        categoryId: Value(categoryId),
        paymentCardId: Value(paymentCardId),
      ),
    );
  }

  Future<void> deleteTransaction(String transactionId) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(transactionId))).go();
  }

  Future<void> addManualTransaction({
    required String id,
    required int amountPaise,
    required String merchant,
    String? paymentCardId,
    String? categoryId,
    String transactionType = 'DEBIT',
    DateTime? occurredAt,
  }) async {
    final now = occurredAt ?? DateTime.now();
    await _db.into(_db.transactions).insert(
      TransactionsCompanion.insert(
        id: id,
        amountPaise: amountPaise,
        merchant: merchant,
        paymentCardId: Value(paymentCardId),
        categoryId: Value(categoryId),
        transactionType: Value(transactionType),
        matchStatus: Value(paymentCardId != null ? 'MANUAL' : 'UNASSIGNED'),
        dedupeFingerprint: 'manual_${id}_${now.millisecondsSinceEpoch}',
        sourceApp: 'MANUAL',
        occurredAt: now,
      ),
    );
  }
}
