import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/cards/data/card_repository.dart';
import 'package:expense_tracker/features/cards/domain/card_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CardRepository cardRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    cardRepo = CardRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Card Management SQLite Unit Tests', () {
    test('Add Card creates persistent card in SQLite with correct properties', () async {
      await cardRepo.addCard(
        id: 'card_axis_1',
        bankName: 'Axis Bank',
        cardType: CardType.credit,
        network: CardNetwork.mastercard,
        maskedNumber: '•••• •••• •••• 5678',
        lastFour: '5678',
        cardholderName: 'Alice',
        nickname: 'Axis Rewards',
        colorGradientIndex: 2,
      );

      final cards = await cardRepo.getActiveCards();
      expect(cards.length, equals(1));
      expect(cards.first.id, equals('card_axis_1'));
      expect(cards.first.bankName, equals('Axis Bank'));
      expect(cards.first.cardType, equals('CREDIT'));
      expect(cards.first.network, equals('Mastercard'));
      expect(cards.first.lastFour, equals('5678'));
      expect(cards.first.nickname, equals('Axis Rewards'));
      expect(cards.first.isActive, isTrue);
    });

    test('Edit Card updates nickname, bankName, and cardType', () async {
      await cardRepo.addCard(
        id: 'card_sbi_1',
        bankName: 'State Bank of India',
        cardType: CardType.debit,
        network: CardNetwork.rupay,
        maskedNumber: '•••• •••• •••• 1122',
        lastFour: '1122',
        nickname: 'SBI Salary',
      );

      await cardRepo.updateCard(
        id: 'card_sbi_1',
        nickname: 'SBI Primary Account',
        bankName: 'SBI',
        cardType: CardType.debit,
        colorGradientIndex: 1,
      );

      final card = await cardRepo.findCardByLastFour('1122');
      expect(card, isNotNull);
      expect(card!.nickname, equals('SBI Primary Account'));
      expect(card.bankName, equals('SBI'));
      expect(card.colorGradientIndex, equals(1));
    });

    test('Activate and Deactivate toggle hides card from active cards stream', () async {
      await cardRepo.addCard(
        id: 'card_icici_temp',
        bankName: 'ICICI Bank',
        cardType: CardType.credit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 9999',
        lastFour: '9999',
      );

      var activeCards = await cardRepo.getActiveCards();
      expect(activeCards.length, equals(1));

      // Deactivate card
      await cardRepo.setCardActive('card_icici_temp', false);
      activeCards = await cardRepo.getActiveCards();
      expect(activeCards.isEmpty, isTrue);

      // findCardByLastFour also excludes inactive cards
      final inactiveLookup = await cardRepo.findCardByLastFour('9999');
      expect(inactiveLookup, isNull);

      // Reactivate card
      await cardRepo.setCardActive('card_icici_temp', true);
      activeCards = await cardRepo.getActiveCards();
      expect(activeCards.length, equals(1));
      expect(activeCards.first.isActive, isTrue);
    });

    test('Delete Card unlinks transactions to UNASSIGNED and deletes card record', () async {
      await cardRepo.addCard(
        id: 'card_to_delete',
        bankName: 'HDFC Bank',
        cardType: CardType.debit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 4321',
        lastFour: '4321',
      );

      // Insert linked transaction
      await db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          id: 'tx_linked_1',
          paymentCardId: const Value('card_to_delete'),
          amountPaise: 150000,
          currency: const Value('INR'),
          merchant: 'Amazon',
          transactionType: const Value('DEBIT'),
          matchStatus: const Value('CONFIRMED'),
          dedupeFingerprint: 'fp_tx_linked_1',
          sourceApp: 'com.snapwork.hdfc',
          occurredAt: DateTime.now(),
        ),
      );

      // Verify transaction is linked
      var tx = await (db.select(db.transactions)..where((t) => t.id.equals('tx_linked_1'))).getSingle();
      expect(tx.paymentCardId, equals('card_to_delete'));
      expect(tx.matchStatus, equals('CONFIRMED'));

      // Delete the card
      await cardRepo.deleteCard('card_to_delete');

      // Card is deleted
      final activeCards = await cardRepo.getActiveCards();
      expect(activeCards.isEmpty, isTrue);

      // Linked transaction preserved but unassigned
      tx = await (db.select(db.transactions)..where((t) => t.id.equals('tx_linked_1'))).getSingle();
      expect(tx.paymentCardId, isNull);
      expect(tx.matchStatus, equals('UNASSIGNED'));
    });
  });
}
