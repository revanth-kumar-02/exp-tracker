import '../../../core/database/app_database.dart';
import '../domain/budget_model.dart';

class BudgetCalculatorService {
  /// Calculates real-time progress for a given budget based on transactions.
  static BudgetProgress calculateProgress({
    required BudgetData budget,
    required List<TransactionData> allTransactions,
    List<PaymentCardData> cards = const [],
    List<CategoryData> categories = const [],
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();

    // Determine calculation date boundaries
    final DateTime startDate = budget.startDate ?? DateTime(now.year, now.month, 1);
    final DateTime endDate = budget.endDate ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final scope = BudgetScope.fromString(budget.scopeType);

    // Resolve human-readable scope name
    String scopeName = 'Overall';
    if (scope == BudgetScope.card && budget.scopeId != null) {
      final card = cards.where((c) => c.id == budget.scopeId).firstOrNull;
      scopeName = card != null ? '${card.bankName} ••${card.lastFour}' : 'Selected Card';
    } else if (scope == BudgetScope.category && budget.scopeId != null) {
      final cat = categories.where((c) => c.id == budget.scopeId).firstOrNull;
      scopeName = cat != null ? cat.name : 'Category';
    }

    // Filter transactions within time window and scope
    int totalSpentPaise = 0;

    for (final tx in allTransactions) {
      // Must be within date window
      if (tx.occurredAt.isBefore(startDate) || tx.occurredAt.isAfter(endDate)) {
        continue;
      }

      // Check scope match
      bool matchesScope = false;
      switch (scope) {
        case BudgetScope.overall:
          matchesScope = true;
          break;
        case BudgetScope.card:
          matchesScope = tx.paymentCardId == budget.scopeId;
          break;
        case BudgetScope.category:
          matchesScope = tx.categoryId == budget.scopeId;
          break;
      }

      if (!matchesScope) continue;

      // Handle transaction direction
      final type = tx.transactionType.toUpperCase();
      if (type == 'DEBIT') {
        totalSpentPaise += tx.amountPaise;
      } else if (type == 'REFUND' || type == 'REVERSAL') {
        totalSpentPaise -= tx.amountPaise;
      }
      // Failed and pending transactions do not count towards settled budget spent
    }

    if (totalSpentPaise < 0) totalSpentPaise = 0;

    return BudgetProgress(
      budgetId: budget.id,
      name: budget.name,
      scope: scope,
      scopeId: budget.scopeId,
      scopeName: scopeName,
      limitPaise: budget.amountLimitPaise,
      spentPaise: totalSpentPaise,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Checks if a newly confirmed transaction causes a budget threshold breach
  static List<BudgetAlert> evaluateThresholdAlerts({
    required List<BudgetData> budgets,
    required List<TransactionData> transactions,
  }) {
    final List<BudgetAlert> alerts = [];

    for (final budget in budgets) {
      final progress = calculateProgress(
        budget: budget,
        allTransactions: transactions,
      );

      if (progress.status == BudgetThresholdStatus.exceeded) {
        alerts.add(BudgetAlert(
          budget: budget,
          progress: progress,
          message: 'Budget exceeded! You have spent ${progress.percentageInt}% of "${budget.name}".',
          isSevere: true,
        ));
      } else if (progress.status == BudgetThresholdStatus.warning) {
        alerts.add(BudgetAlert(
          budget: budget,
          progress: progress,
          message: 'Approaching limit: You have spent ${progress.percentageInt}% of "${budget.name}".',
          isSevere: false,
        ));
      }
    }

    return alerts;
  }
}

class BudgetAlert {
  final BudgetData budget;
  final BudgetProgress progress;
  final String message;
  final bool isSevere;

  const BudgetAlert({
    required this.budget,
    required this.progress,
    required this.message,
    required this.isSevere,
  });
}
