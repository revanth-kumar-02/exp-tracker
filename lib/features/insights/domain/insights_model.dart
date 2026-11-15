class CategorySpending {
  final String categoryId;
  final String categoryName;
  final String icon;
  final String colorHex;
  final int spentPaise;
  final double percentage;
  final int transactionCount;

  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.icon,
    required this.colorHex,
    required this.spentPaise,
    required this.percentage,
    required this.transactionCount,
  });

  int get percentageInt => (percentage * 100).round();
}

class CardTypeComparison {
  final int debitSpentPaise;
  final int creditSpentPaise;
  final int debitCount;
  final int creditCount;

  const CardTypeComparison({
    required this.debitSpentPaise,
    required this.creditSpentPaise,
    required this.debitCount,
    required this.creditCount,
  });

  int get totalPaise => debitSpentPaise + creditSpentPaise;

  double get debitPercentage =>
      totalPaise > 0 ? debitSpentPaise / totalPaise : 0.0;

  double get creditPercentage =>
      totalPaise > 0 ? creditSpentPaise / totalPaise : 0.0;
}

class TopMerchant {
  final String merchant;
  final int spentPaise;
  final int transactionCount;

  const TopMerchant({
    required this.merchant,
    required this.spentPaise,
    required this.transactionCount,
  });
}

class InsightsData {
  final int totalSpentPaise;
  final int totalTransactionsCount;
  final double monthOverMonthChangePercent;
  final List<CategorySpending> categoryBreakdown;
  final CardTypeComparison cardTypeComparison;
  final List<TopMerchant> topMerchants;

  const InsightsData({
    required this.totalSpentPaise,
    required this.totalTransactionsCount,
    required this.monthOverMonthChangePercent,
    required this.categoryBreakdown,
    required this.cardTypeComparison,
    required this.topMerchants,
  });
}
