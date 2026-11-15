enum BudgetScope {
  overall('OVERALL', 'Overall Spending'),
  card('CARD', 'Card Specific'),
  category('CATEGORY', 'Category Specific');

  final String dbValue;
  final String displayName;

  const BudgetScope(this.dbValue, this.displayName);

  static BudgetScope fromString(String val) {
    for (final s in BudgetScope.values) {
      if (s.dbValue == val || s.name == val) return s;
    }
    return BudgetScope.overall;
  }
}

enum BudgetPeriod {
  monthly('MONTHLY', 'Monthly'),
  weekly('WEEKLY', 'Weekly');

  final String dbValue;
  final String displayName;

  const BudgetPeriod(this.dbValue, this.displayName);

  static BudgetPeriod fromString(String val) {
    if (val.toUpperCase() == 'WEEKLY') return BudgetPeriod.weekly;
    return BudgetPeriod.monthly;
  }
}

enum BudgetThresholdStatus {
  safe,     // < 75%
  warning,  // >= 75% and < 100%
  exceeded, // >= 100%
}

class BudgetProgress {
  final String budgetId;
  final String name;
  final BudgetScope scope;
  final String? scopeId;
  final String? scopeName;
  final int limitPaise;
  final int spentPaise;
  final DateTime startDate;
  final DateTime endDate;

  const BudgetProgress({
    required this.budgetId,
    required this.name,
    required this.scope,
    this.scopeId,
    this.scopeName,
    required this.limitPaise,
    required this.spentPaise,
    required this.startDate,
    required this.endDate,
  });

  int get remainingPaise => limitPaise - spentPaise;

  double get percentage =>
      limitPaise > 0 ? (spentPaise / limitPaise).clamp(0.0, 2.0) : 0.0;

  int get percentageInt => (percentage * 100).round();

  BudgetThresholdStatus get status {
    if (percentage >= 1.0) return BudgetThresholdStatus.exceeded;
    if (percentage >= 0.75) return BudgetThresholdStatus.warning;
    return BudgetThresholdStatus.safe;
  }

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays + 1;
  }

  int get dailyAllowancePaise {
    final days = daysRemaining;
    if (days <= 0 || remainingPaise <= 0) return 0;
    return remainingPaise ~/ days;
  }
}
