import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../domain/card_enums.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepository(ref.watch(databaseProvider));
});

class CardRepository {
  final AppDatabase _db;

  CardRepository(this._db);

  Stream<List<PaymentCardData>> watchActiveCards() {
    return (_db.select(_db.paymentCards)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<PaymentCardData>> getActiveCards() {
    return (_db.select(_db.paymentCards)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<PaymentCardData?> findCardByLastFour(String lastFour) {
    return (_db.select(_db.paymentCards)
          ..where((tbl) => tbl.lastFour.equals(lastFour) & tbl.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<void> addCard({
    required String id,
    required String bankName,
    required CardType cardType,
    required CardNetwork network,
    required String maskedNumber,
    required String lastFour,
    String? cardholderName,
    String? expiryMonthYear,
    String? nickname,
    int colorGradientIndex = 0,
  }) async {
    await _db.into(_db.paymentCards).insert(
      PaymentCardsCompanion.insert(
        id: id,
        bankName: bankName,
        cardType: cardType.dbValue,
        network: network.displayName,
        maskedNumber: maskedNumber,
        lastFour: lastFour,
        cardholderName: Value(cardholderName),
        expiryMonthYear: Value(expiryMonthYear),
        nickname: Value(nickname),
        colorGradientIndex: Value(colorGradientIndex),
      ),
    );
  }

  Future<void> updateCard({
    required String id,
    String? nickname,
    int? colorGradientIndex,
  }) async {
    await (_db.update(_db.paymentCards)..where((t) => t.id.equals(id))).write(
      PaymentCardsCompanion(
        nickname: nickname != null ? Value(nickname) : const Value.absent(),
        colorGradientIndex: colorGradientIndex != null
            ? Value(colorGradientIndex)
            : const Value.absent(),
      ),
    );
  }

  Future<void> deleteCard(String id) async {
    await (_db.update(_db.paymentCards)..where((t) => t.id.equals(id))).write(
      const PaymentCardsCompanion(isActive: Value(false)),
    );
  }
}
