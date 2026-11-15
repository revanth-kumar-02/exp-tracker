import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/cards/presentation/controllers/card_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Dashboard renders cards and overview elements correctly', (WidgetTester tester) async {
    final mockCard = PaymentCardData(
      id: 'test_card_1',
      bankName: 'HDFC Bank',
      cardType: 'DEBIT',
      network: 'VISA',
      maskedNumber: '•••• •••• •••• 4821',
      lastFour: '4821',
      colorGradientIndex: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );

    final mockOverview = const DashboardSpendingOverview(
      totalSpentPaise: 2456000,
      monthOverMonthChangePercent: -12.0,
      cardMetrics: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cardsStreamProvider.overrideWith((ref) => Stream.value([mockCard])),
          dashboardSpendingProvider.overrideWith((ref) => Stream.value(mockOverview)),
        ],
        child: const ExpenseTrackerApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify UI branding & headers
    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Good evening 👋'), findsOneWidget);
    expect(find.text('Cards Overview'), findsOneWidget);

    // Verify Filter Pills
    expect(find.text('All Cards (1)'), findsOneWidget);
    expect(find.text('Debit (1)'), findsOneWidget);
    expect(find.text('Credit (0)'), findsOneWidget);

    // Verify Quick Actions & Bottom Navigation
    expect(find.text('Add Card'), findsOneWidget);
    expect(find.text('Budgets'), findsNWidgets(2)); // Quick action + Bottom nav tab
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Card Bills'), findsOneWidget);

    // Verify Bottom Navigation Items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Cards'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
  });
}
