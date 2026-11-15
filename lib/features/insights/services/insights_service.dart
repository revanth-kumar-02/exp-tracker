import '../../../core/database/app_database.dart';
import '../domain/insights_model.dart';

class InsightsService {
  static InsightsData calculateInsights({
    required List<TransactionData> transactions,
    required List<CategoryData> categories,
    required List<PaymentCardData> cards,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final startOfCurrentMonth = DateTime(now.year, now.month, 1);
    final startOfPrevMonth = DateTime(now.year, now.month - 1, 1);
    final endOfPrevMonth = DateTime(now.year, now.month, 0, 23, 59, 59);

    // Filter current month debits (expenses)
    final currentMonthTxs = transactions.where((tx) =>
      tx.occurredAt.isAfter(startOfCurrentMonth) &&
      tx.transactionType.toUpperCase() == 'DEBIT'
    ).toList();

    // Previous month debits for comparison
    final prevMonthTxs = transactions.where((tx) =>
      tx.occurredAt.isAfter(startOfPrevMonth) &&
      tx.occurredAt.isBefore(endOfPrevMonth) &&
      tx.transactionType.toUpperCase() == 'DEBIT'
    ).toList();

    int currentTotal = 0;
    for (final tx in currentMonthTxs) {
      currentTotal += tx.amountPaise;
    }

    int prevTotal = 0;
    for (final tx in prevMonthTxs) {
      prevTotal += tx.amountPaise;
    }

    double deltaPercent = 0.0;
    if (prevTotal > 0) {
      deltaPercent = ((currentTotal - prevTotal) / prevTotal) * 100.0;
    } else if (currentTotal > 0) {
      deltaPercent = 100.0;
    }

    // 1. Category Breakdown
    final Map<String, int> categorySpendMap = {};
    final Map<String, int> categoryCountMap = {};

    for (final tx in currentMonthTxs) {
      final catId = tx.categoryId ?? 'cat_other';
      categorySpendMap[catId] = (categorySpendMap[catId] ?? 0) + tx.amountPaise;
      categoryCountMap[catId] = (categoryCountMap[catId] ?? 0) + 1;
    }

    final List<CategorySpending> categoryBreakdown = [];
    categorySpendMap.forEach((catId, spent) {
      final category = categories.where((c) => c.id == catId).firstOrNull;
      final name = category?.name ?? (catId == 'cat_other' ? 'Other' : 'Uncategorized');
      final icon = category?.icon ?? 'more_horiz';
      final colorHex = category?.colorHex ?? '#8B5CF6';
      final double pct = currentTotal > 0 ? (spent / currentTotal) : 0.0;

      categoryBreakdown.add(CategorySpending(
        categoryId: catId,
        categoryName: name,
        icon: icon,
        colorHex: colorHex,
        spentPaise: spent,
        percentage: pct,
        transactionCount: categoryCountMap[catId] ?? 1,
      ));
    });

    categoryBreakdown.sort((a, b) => b.spentPaise.compareTo(a.spentPaise));

    // 2. Card Type Comparison (Debit vs Credit)
    int debitSpend = 0;
    int creditSpend = 0;
    int debitCount = 0;
    int creditCount = 0;

    final cardMap = {for (final c in cards) c.id: c};

    for (final tx in currentMonthTxs) {
      if (tx.paymentCardId != null && cardMap.containsKey(tx.paymentCardId)) {
        final card = cardMap[tx.paymentCardId]!;
        if (card.cardType.toUpperCase() == 'CREDIT') {
          creditSpend += tx.amountPaise;
          creditCount++;
        } else {
          debitSpend += tx.amountPaise;
          debitCount++;
        }
      } else {
        // Fallback to debit if unassigned
        debitSpend += tx.amountPaise;
        debitCount++;
      }
    }

    final cardTypeComparison = CardTypeComparison(
      debitSpentPaise: debitSpend,
      creditSpentPaise: creditSpend,
      debitCount: debitCount,
      creditCount: creditCount,
    );

    // 3. Top Merchants
    final Map<String, int> merchantSpendMap = {};
    final Map<String, int> merchantCountMap = {};

    for (final tx in currentMonthTxs) {
      final merchant = tx.merchant.trim();
      merchantSpendMap[merchant] = (merchantSpendMap[merchant] ?? 0) + tx.amountPaise;
      merchantCountMap[merchant] = (merchantCountMap[merchant] ?? 0) + 1;
    }

    final List<TopMerchant> topMerchants = merchantSpendMap.entries.map((entry) {
      return TopMerchant(
        merchant: entry.key,
        spentPaise: entry.value,
        transactionCount: merchantCountMap[entry.key] ?? 1,
      );
    }).toList();

    topMerchants.sort((a, b) => b.spentPaise.compareTo(a.spentPaise));

    return InsightsData(
      totalSpentPaise: currentTotal,
      totalTransactionsCount: currentMonthTxs.length,
      monthOverMonthChangePercent: deltaPercent,
      categoryBreakdown: categoryBreakdown,
      cardTypeComparison: cardTypeComparison,
      topMerchants: topMerchants.take(5).toList(),
    );
  }
}
