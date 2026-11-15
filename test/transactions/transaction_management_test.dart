import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/cards/data/card_repository.dart';
import 'package:expense_tracker/features/cards/domain/card_enums.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository.dart';

void main() {
  late AppDatabase db;
  late CardRepository cardRepo;
  late TransactionRepository txRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    cardRepo = CardRepository(db);
    txRepo = TransactionRepository(db);

    // Register a test card
    await cardRepo.addCard(
      id: 'card_hdfc_4821',
      bankName: 'HDFC Bank',
      cardType: CardType.debit,
      network: CardNetwork.visa,
      maskedNumber: '•••• •••• •••• 4821',
      lastFour: '4821',
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Transaction Management & Unassigned Queue Tests', () {
    test('Unassigned count tracks unmatched notifications', () async {
      // Initially 0
      final initialCount = await txRepo.watchUnassignedCount().first;
      expect(initialCount, equals(0));

      // Add unassigned transaction
      await txRepo.addManualTransaction(
        id: 'tx_unassigned_1',
        amountPaise: 45000,
        merchant: 'Swiggy',
        paymentCardId: null, // Unassigned
      );

      final countAfter1 = await txRepo.watchUnassignedCount().first;
      expect(countAfter1, equals(1));

      // Add confirmed transaction
      await txRepo.addManualTransaction(
        id: 'tx_confirmed_1',
        amountPaise: 120000,
        merchant: 'Flipkart',
        paymentCardId: 'card_hdfc_4821',
      );

      // Unassigned count remains 1
      final countAfterConfirmed = await txRepo.watchUnassignedCount().first;
      expect(countAfterConfirmed, equals(1));
    });

    test('Assigning card and category updates transaction status to MANUAL', () async {
      await txRepo.addManualTransaction(
        id: 'tx_to_assign',
        amountPaise: 25000,
        merchant: 'Zomato',
        paymentCardId: null,
      );

      // Assign card
      await txRepo.assignCardAndCategory(
        transactionId: 'tx_to_assign',
        cardId: 'card_hdfc_4821',
        categoryId: 'cat_food',
      );

      final txList = await txRepo.watchTransactions().first;
      final updated = txList.firstWhere((t) => t.id == 'tx_to_assign');

      expect(updated.paymentCardId, equals('card_hdfc_4821'));
      expect(updated.categoryId, equals('cat_food'));
      expect(updated.matchStatus, equals('MANUAL'));

      // Unassigned count drops to 0
      final count = await txRepo.watchUnassignedCount().first;
      expect(count, equals(0));
    });

    test('Filters transactions by payment card ID', () async {
      await txRepo.addManualTransaction(
        id: 'tx_card_1',
        amountPaise: 50000,
        merchant: 'Store A',
        paymentCardId: 'card_hdfc_4821',
      );
      await txRepo.addManualTransaction(
        id: 'tx_card_other',
        amountPaise: 70000,
        merchant: 'Store B',
        paymentCardId: 'other_card_9999',
      );

      final hdfcTxs = await txRepo.watchTransactions(cardId: 'card_hdfc_4821').first;
      expect(hdfcTxs.length, equals(1));
      expect(hdfcTxs.first.merchant, equals('Store A'));
    });

    test('Can delete a transaction', () async {
      await txRepo.addManualTransaction(
        id: 'tx_to_delete',
        amountPaise: 15000,
        merchant: 'Cafe',
      );

      final before = await txRepo.watchTransactions().first;
      expect(before.length, equals(1));

      await txRepo.deleteTransaction('tx_to_delete');

      final after = await txRepo.watchTransactions().first;
      expect(after.isEmpty, isTrue);
    });
  });
}
