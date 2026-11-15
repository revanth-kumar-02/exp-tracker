import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/insights/services/insights_service.dart';

void main() {
  group('InsightsService Tests', () {
    final now = DateTime(2026, 11, 15, 12, 0);

    final mockCategories = [
      CategoryData(
        id: 'cat_food',
        name: 'Food & Dining',
        icon: 'restaurant',
        colorHex: '#FF5722',
        isCustom: false,
      ),
      CategoryData(
        id: 'cat_shopping',
        name: 'Shopping',
        icon: 'shopping_bag',
        colorHex: '#9C27B0',
        isCustom: false,
      ),
    ];

    final mockCards = [
      PaymentCardData(
        id: 'card_1',
        bankName: 'HDFC Bank',
        lastFour: '1234',
        cardType: 'CREDIT',
        nickname: 'HDFC Regalia',
        network: 'VISA',
        maskedNumber: '•••• •••• •••• 1234',
        colorGradientIndex: 0,
        isActive: true,
        createdAt: now,
      ),
      PaymentCardData(
        id: 'card_2',
        bankName: 'SBI',
        lastFour: '5678',
        cardType: 'DEBIT',
        nickname: 'SBI Global',
        network: 'RUPAY',
        maskedNumber: '•••• •••• •••• 5678',
        colorGradientIndex: 1,
        isActive: true,
        createdAt: now,
      ),
    ];

    test('calculates category breakdown, debit vs credit, and top merchants correctly', () {
      final transactions = [
        TransactionData(
          id: 'tx_1',
          paymentCardId: 'card_1', // Credit
          amountPaise: 50000, // 500 INR
          currency: 'INR',
          transactionType: 'DEBIT',
          merchant: 'Swiggy',
          categoryId: 'cat_food',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'fp_1',
          sourceApp: 'com.hdfc.bank',
          occurredAt: DateTime(2026, 11, 10),
          createdAt: now,
        ),
        TransactionData(
          id: 'tx_2',
          paymentCardId: 'card_1', // Credit
          amountPaise: 150000, // 1500 INR
          currency: 'INR',
          transactionType: 'DEBIT',
          merchant: 'Amazon',
          categoryId: 'cat_shopping',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'fp_2',
          sourceApp: 'com.hdfc.bank',
          occurredAt: DateTime(2026, 11, 12),
          createdAt: now,
        ),
        TransactionData(
          id: 'tx_3',
          paymentCardId: 'card_2', // Debit
          amountPaise: 50000, // 500 INR
          currency: 'INR',
          transactionType: 'DEBIT',
          merchant: 'Swiggy',
          categoryId: 'cat_food',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'fp_3',
          sourceApp: 'com.sbi.bank',
          occurredAt: DateTime(2026, 11, 14),
          createdAt: now,
        ),
        // Previous month transaction for MoM change comparison
        TransactionData(
          id: 'tx_prev',
          paymentCardId: 'card_1',
          amountPaise: 100000, // 1000 INR
          currency: 'INR',
          transactionType: 'DEBIT',
          merchant: 'Flipkart',
          categoryId: 'cat_shopping',
          matchStatus: 'CONFIRMED',
          dedupeFingerprint: 'fp_prev',
          sourceApp: 'com.hdfc.bank',
          occurredAt: DateTime(2026, 10, 15),
          createdAt: now,
        ),
      ];

      final insights = InsightsService.calculateInsights(
        transactions: transactions,
        categories: mockCategories,
        cards: mockCards,
        referenceDate: now,
      );

      // Current month total: 50000 + 150000 + 50000 = 250000 paise (2500 INR)
      expect(insights.totalSpentPaise, equals(250000));
      expect(insights.totalTransactionsCount, equals(3));

      // MoM: prev = 100000, curr = 250000 -> +150%
      expect(insights.monthOverMonthChangePercent, equals(150.0));

      // Category breakdown
      expect(insights.categoryBreakdown.length, equals(2));
      final shopping = insights.categoryBreakdown.firstWhere((c) => c.categoryId == 'cat_shopping');
      final food = insights.categoryBreakdown.firstWhere((c) => c.categoryId == 'cat_food');
      expect(shopping.spentPaise, equals(150000));
      expect(food.spentPaise, equals(100000));
      expect(shopping.percentage, closeTo(0.6, 0.01));
      expect(food.percentage, closeTo(0.4, 0.01));

      // Card Type Comparison: Credit = 200000, Debit = 50000
      expect(insights.cardTypeComparison.creditSpentPaise, equals(200000));
      expect(insights.cardTypeComparison.debitSpentPaise, equals(50000));
      expect(insights.cardTypeComparison.creditCount, equals(2));
      expect(insights.cardTypeComparison.debitCount, equals(1));

      // Top Merchants
      expect(insights.topMerchants.length, equals(2));
      expect(insights.topMerchants.first.merchant, equals('Amazon'));
      expect(insights.topMerchants.first.spentPaise, equals(150000));
      expect(insights.topMerchants[1].merchant, equals('Swiggy'));
      expect(insights.topMerchants[1].spentPaise, equals(100000));
      expect(insights.topMerchants[1].transactionCount, equals(2));
    });
  });
}
