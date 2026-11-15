import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart' hide isNull;

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Database seeds default categories on creation', () async {
    final categories = await db.select(db.categories).get();
    expect(categories.length, equals(6));
    expect(categories.map((c) => c.name), contains('Food & Dining'));
  });

  test('Can insert and retrieve a payment card', () async {
    await db.into(db.paymentCards).insert(
      PaymentCardsCompanion.insert(
        id: 'card_1',
        bankName: 'HDFC Bank',
        cardType: 'DEBIT',
        nickname: const Value('Personal HDFC'),
        network: 'VISA',
        maskedNumber: '•••• •••• •••• 4821',
        lastFour: '4821',
        cardholderName: const Value('John Doe'),
        expiryMonthYear: const Value('12/28'),
        colorGradientIndex: const Value(0),
      ),
    );

    final cards = await db.select(db.paymentCards).get();
    expect(cards.length, equals(1));
    expect(cards.first.bankName, equals('HDFC Bank'));
    expect(cards.first.lastFour, equals('4821'));
  });

  test('Can insert and link a transaction with nullable card assignment', () async {
    // 1. Insert unassigned transaction (paymentCardId is null)
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        id: 'tx_unassigned',
        amountPaise: 45000,
        merchant: 'Swiggy',
        sourceApp: 'com.snapwork.hdfc',
        dedupeFingerprint: 'hash_123',
        matchStatus: const Value('UNASSIGNED'),
        occurredAt: DateTime.now(),
      ),
    );

    final txList = await db.select(db.transactions).get();
    expect(txList.length, equals(1));
    expect(txList.first.paymentCardId, isNull);
    expect(txList.first.matchStatus, equals('UNASSIGNED'));
    expect(txList.first.amountPaise, equals(45000));
  });

  test('Enforces unique deduplication fingerprint on transactions', () async {
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        id: 'tx_1',
        amountPaise: 10000,
        merchant: 'Uber',
        sourceApp: 'com.snapwork.hdfc',
        dedupeFingerprint: 'duplicate_hash',
        occurredAt: DateTime.now(),
      ),
    );

    // Attempting to insert identical dedupeFingerprint should throw exception
    expect(
      () => db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          id: 'tx_2',
          amountPaise: 10000,
          merchant: 'Uber',
          sourceApp: 'com.snapwork.hdfc',
          dedupeFingerprint: 'duplicate_hash',
          occurredAt: DateTime.now(),
        ),
      ),
      throwsA(isA<SqliteException>()),
    );
  });
}
