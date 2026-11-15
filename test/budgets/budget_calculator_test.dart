import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/budgets/domain/budget_model.dart';
import 'package:expense_tracker/features/budgets/services/budget_calculator_service.dart';

void main() {
  final now = DateTime(2026, 11, 15, 12, 0);

  final sampleCard1 = PaymentCardData(
    id: 'card_1',
    bankName: 'HDFC Bank',
    cardType: 'DEBIT',
    network: 'VISA',
    maskedNumber: '•••• •••• •••• 4821',
    lastFour: '4821',
    colorGradientIndex: 0,
    isActive: true,
    createdAt: now,
  );

  final sampleCard2 = PaymentCardData(
    id: 'card_2',
    bankName: 'SBI Bank',
    cardType: 'CREDIT',
    network: 'VISA',
    maskedNumber: '•••• •••• •••• 7290',
    lastFour: '7290',
    colorGradientIndex: 1,
    isActive: true,
    createdAt: now,
  );

  group('Budget Calculator Service Unit Tests', () {
    test('Calculates overall monthly budget correctly', () {
      final budget = BudgetData(
        id: 'budget_overall',
        name: 'Monthly Limit',
        period: 'MONTHLY',
        amountLimitPaise: 5000000, // ₹50,000 limit
        scopeType: 'OVERALL',
        createdAt: now,
      );

      final txs = [
        TransactionData(
          id: 'tx_1',
          paymentCardId: 'card_1',
          categoryId: 'cat_food',
          amountPaise: 1000000, // ₹10,000 debit
          currency: 'INR',
          merchant: 'Swiggy',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'h1',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 5),
          createdAt: now,
        ),
        TransactionData(
          id: 'tx_2',
          paymentCardId: 'card_2',
          categoryId: 'cat_travel',
          amountPaise: 1500000, // ₹15,000 debit
          currency: 'INR',
          merchant: 'Flight',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'h2',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 10),
          createdAt: now,
        ),
      ];

      final progress = BudgetCalculatorService.calculateProgress(
        budget: budget,
        allTransactions: txs,
        referenceDate: now,
      );

      expect(progress.spentPaise, equals(2500000)); // ₹25,000 spent
      expect(progress.remainingPaise, equals(2500000)); // ₹25,000 left
      expect(progress.percentageInt, equals(50)); // 50%
      expect(progress.status, equals(BudgetThresholdStatus.safe));
    });

    test('Refund transaction offsets total spent amount', () {
      final budget = BudgetData(
        id: 'budget_overall',
        name: 'Monthly Limit',
        period: 'MONTHLY',
        amountLimitPaise: 2000000, // ₹20,000
        scopeType: 'OVERALL',
        createdAt: now,
      );

      final txs = [
        TransactionData(
          id: 'tx_debit',
          amountPaise: 1000000, // ₹10,000 debit
          currency: 'INR',
          merchant: 'Store',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'h3',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 5),
          createdAt: now,
        ),
        TransactionData(
          id: 'tx_refund',
          amountPaise: 300000, // ₹3,000 refund
          currency: 'INR',
          merchant: 'Store',
          transactionType: 'REFUND',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'h4',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 6),
          createdAt: now,
        ),
      ];

      final progress = BudgetCalculatorService.calculateProgress(
        budget: budget,
        allTransactions: txs,
        referenceDate: now,
      );

      expect(progress.spentPaise, equals(700000)); // ₹7,000 net spent
      expect(progress.remainingPaise, equals(1300000));
    });

    test('Card-scoped budget only includes transactions matching that card', () {
      final budget = BudgetData(
        id: 'budget_card1',
        name: 'HDFC Limit',
        period: 'MONTHLY',
        amountLimitPaise: 1000000, // ₹10,000
        scopeType: 'CARD',
        scopeId: 'card_1',
        createdAt: now,
      );

      final txs = [
        TransactionData(
          id: 'tx_c1',
          paymentCardId: 'card_1', // Card 1: counts
          amountPaise: 400000, // ₹4,000
          currency: 'INR',
          merchant: 'Swiggy',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'h5',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 5),
          createdAt: now,
        ),
        TransactionData(
          id: 'tx_c2',
          paymentCardId: 'card_2', // Card 2: must be ignored!
          amountPaise: 800000, // ₹8,000
          currency: 'INR',
          merchant: 'Flipkart',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'h6',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 6),
          createdAt: now,
        ),
      ];

      final progress = BudgetCalculatorService.calculateProgress(
        budget: budget,
        allTransactions: txs,
        cards: [sampleCard1, sampleCard2],
        referenceDate: now,
      );

      expect(progress.spentPaise, equals(400000)); // Only ₹4,000 counted
      expect(progress.remainingPaise, equals(600000));
      expect(progress.percentageInt, equals(40));
    });

    test('Detects warning (>= 75%) and exceeded (>= 100%) thresholds', () {
      final budgetWarning = BudgetData(
        id: 'b_warn',
        name: 'Dining Out',
        period: 'MONTHLY',
        amountLimitPaise: 1000000, // ₹10,000
        scopeType: 'OVERALL',
        createdAt: now,
      );

      final txWarning = [
        TransactionData(
          id: 'tx_w',
          amountPaise: 800000, // ₹8,000 (80%)
          currency: 'INR',
          merchant: 'Dining',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'hw',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 8),
          createdAt: now,
        ),
      ];

      final progressWarning = BudgetCalculatorService.calculateProgress(
        budget: budgetWarning,
        allTransactions: txWarning,
        referenceDate: now,
      );
      expect(progressWarning.status, equals(BudgetThresholdStatus.warning));

      // Now add transaction exceeding limit
      final txExceeded = [
        ...txWarning,
        TransactionData(
          id: 'tx_ex',
          amountPaise: 300000, // Additional ₹3,000 (total ₹11,000 = 110%)
          currency: 'INR',
          merchant: 'Dining 2',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'hex',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 9),
          createdAt: now,
        ),
      ];

      final progressExceeded = BudgetCalculatorService.calculateProgress(
        budget: budgetWarning,
        allTransactions: txExceeded,
        referenceDate: now,
      );
      expect(progressExceeded.status, equals(BudgetThresholdStatus.exceeded));
      expect(progressExceeded.remainingPaise, equals(-100000)); // ₹1,000 over budget
    });

    test('Generates threshold alerts for breached budgets', () {
      final budget = BudgetData(
        id: 'b_alert',
        name: 'Shopping Limit',
        period: 'MONTHLY',
        amountLimitPaise: 1000000, // ₹10,000
        scopeType: 'OVERALL',
        createdAt: now,
      );

      final txs = [
        TransactionData(
          id: 'tx_a',
          amountPaise: 850000, // ₹8,500 (85% -> Warning)
          currency: 'INR',
          merchant: 'Zara',
          transactionType: 'DEBIT',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'ha',
          sourceApp: 'app',
          occurredAt: DateTime(2026, 11, 10),
          createdAt: now,
        ),
      ];

      final alerts = BudgetCalculatorService.evaluateThresholdAlerts(
        budgets: [budget],
        transactions: txs,
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.isSevere, isFalse);
      expect(alerts.first.message, contains('Approaching limit'));
    });
  });
}
