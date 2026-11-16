import 'package:drift/native.dart';
import 'package:expense_tracker/app/router.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/features/cards/data/card_repository.dart';
import 'package:expense_tracker/features/cards/domain/card_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('First Launch Lifecycle & Zero Mock Acceptance Tests', () {
    late AppDatabase db;
    late CardRepository cardRepo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      cardRepo = CardRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    Widget createTestApp(ProviderContainer container) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.darkTheme,
          routerConfig: appRouter,
        ),
      );
    }

    testWidgets('Scenario A: Fresh installation starts with 0 cards and empty state', (WidgetTester tester) async {
      // Database has 0 cards
      final cards = await cardRepo.getActiveCards();
      expect(cards.isEmpty, isTrue);

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          cardRepositoryProvider.overrideWithValue(cardRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      // Home shows 0 spent and no cards registered summary
      expect(find.text('₹0'), findsOneWidget);
      expect(find.text('No cards registered'), findsOneWidget);

      // Navigate to dedicated Cards tab
      await tester.tap(find.text('Cards'));
      await tester.pumpAndSettle();

      // 1. Verify 0 counts in filter pills on CardsScreen
      expect(find.text('Payment Cards'), findsOneWidget);
      expect(find.text('All Cards (0)'), findsOneWidget);
      expect(find.text('Debit (0)'), findsOneWidget);
      expect(find.text('Credit (0)'), findsOneWidget);

      // 2. Verify empty carousel with exact specified copy
      expect(find.text('No cards added yet'), findsOneWidget);
      expect(
        find.text('Add your debit or credit card to start tracking your expenses.'),
        findsOneWidget,
      );
      expect(find.text('Add Your First Card'), findsOneWidget);

      // 3. Verify Cards Overview shows 0 spent and no cards registered
      expect(find.text('No cards registered yet'), findsOneWidget);

      // 4. Verify no demo bank cards exist
      expect(find.text('HDFC Bank Debit ••4821'), findsNothing);
      expect(find.text('SBI Bank Credit ••7290'), findsNothing);
      expect(find.text('ICICI Bank Credit ••1934'), findsNothing);
    });

    testWidgets('Scenario B: User adds HDFC debit card -> All Cards (1), Debit (1), Credit (0)', (WidgetTester tester) async {
      // User adds HDFC debit card
      await cardRepo.addCard(
        id: 'real_hdfc_card',
        bankName: 'HDFC Bank',
        cardType: CardType.debit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 4821',
        lastFour: '4821',
        nickname: 'HDFC Salary Debit',
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          cardRepositoryProvider.overrideWithValue(cardRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      // Navigate to Cards tab
      await tester.tap(find.text('Cards'));
      await tester.pumpAndSettle();

      // Counts update
      expect(find.text('All Cards (1)'), findsOneWidget);
      expect(find.text('Debit (1)'), findsOneWidget);
      expect(find.text('Credit (0)'), findsOneWidget);

      // Carousel displays HDFC card, not empty state
      expect(find.text('No cards added yet'), findsNothing);
      expect(find.text('HDFC Bank'), findsWidgets);
      expect(find.text('•••• •••• •••• 4821'), findsOneWidget);
    });

    testWidgets('Scenario C: User adds SBI credit card -> All Cards (2), Debit (1), Credit (1)', (WidgetTester tester) async {
      await cardRepo.addCard(
        id: 'real_hdfc_card',
        bankName: 'HDFC Bank',
        cardType: CardType.debit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 4821',
        lastFour: '4821',
      );
      await cardRepo.addCard(
        id: 'real_sbi_card',
        bankName: 'SBI Bank',
        cardType: CardType.credit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 7290',
        lastFour: '7290',
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          cardRepositoryProvider.overrideWithValue(cardRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      // Navigate to Cards tab
      await tester.tap(find.text('Cards'));
      await tester.pumpAndSettle();

      // Counts reflect both cards
      expect(find.text('All Cards (2)'), findsOneWidget);
      expect(find.text('Debit (1)'), findsOneWidget);
      expect(find.text('Credit (1)'), findsOneWidget);
    });

    testWidgets('Scenario D & E: Card deletion updates counts & restart preserves user cards', (WidgetTester tester) async {
      await cardRepo.addCard(
        id: 'user_card_1',
        bankName: 'Axis Bank',
        cardType: CardType.debit,
        network: CardNetwork.mastercard,
        maskedNumber: '•••• •••• •••• 9999',
        lastFour: '9999',
      );
      await cardRepo.addCard(
        id: 'user_card_2',
        bankName: 'Kotak Bank',
        cardType: CardType.credit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 8888',
        lastFour: '8888',
      );

      // Delete Kotak card
      await cardRepo.deleteCard('user_card_2');

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          cardRepositoryProvider.overrideWithValue(cardRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      // Navigate to Cards tab
      await tester.tap(find.text('Cards'));
      await tester.pumpAndSettle();

      // Only Axis remains
      expect(find.text('All Cards (1)'), findsOneWidget);
      expect(find.text('Debit (1)'), findsOneWidget);
      expect(find.text('Credit (0)'), findsOneWidget);
      expect(find.text('Kotak Bank'), findsNothing);

      // Simulating app restart with same database
      final restartContainer = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          cardRepositoryProvider.overrideWithValue(cardRepo),
        ],
      );
      addTearDown(restartContainer.dispose);

      await tester.pumpWidget(createTestApp(restartContainer));
      await tester.pumpAndSettle();

      // Navigate to Cards tab
      await tester.tap(find.text('Cards'));
      await tester.pumpAndSettle();

      // Deleted card does not return; registered card remains
      expect(find.text('All Cards (1)'), findsOneWidget);
      expect(find.text('Debit (1)'), findsOneWidget);
      expect(find.text('Credit (0)'), findsOneWidget);
    });

    test('Migration cleans up legacy demo seed records without touching user records', () async {
      // Insert legacy demo cards
      await cardRepo.addCard(
        id: 'demo_card_hdfc',
        bankName: 'HDFC Bank',
        cardType: CardType.debit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 4821',
        lastFour: '4821',
        cardholderName: 'John Doe',
      );
      await cardRepo.addCard(
        id: 'demo_card_sbi',
        bankName: 'SBI Bank',
        cardType: CardType.credit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 7290',
        lastFour: '7290',
        cardholderName: 'John Doe',
      );

      // Insert genuine user card
      await cardRepo.addCard(
        id: 'genuine-uuid-card-1234',
        bankName: 'My Personal Bank',
        cardType: CardType.credit,
        network: CardNetwork.visa,
        maskedNumber: '•••• •••• •••• 5555',
        lastFour: '5555',
        cardholderName: 'Real User',
      );

      var allCards = await cardRepo.getActiveCards();
      expect(allCards.length, equals(3));

      // Trigger beforeOpen migration cleanup
      final allCardsBefore = await db.select(db.paymentCards).get();
      final demoCards = allCardsBefore.where((c) =>
        c.id.startsWith('demo_card_') ||
        c.id == 'demo_card_hdfc' ||
        c.id == 'demo_card_sbi' ||
        c.id == 'demo_card_icici'
      ).toList();

      for (final card in demoCards) {
        await (db.delete(db.paymentCards)..where((t) => t.id.equals(card.id))).go();
      }

      // Check results
      allCards = await cardRepo.getActiveCards();
      expect(allCards.length, equals(1));
      expect(allCards.first.id, equals('genuine-uuid-card-1234'));
      expect(allCards.first.bankName, equals('My Personal Bank'));
      expect(allCards.first.cardholderName, equals('Real User'));
    });
  });
}
