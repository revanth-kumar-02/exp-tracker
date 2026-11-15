import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../cards/data/card_repository.dart';
import '../../../cards/presentation/controllers/card_controller.dart';
import '../../data/budget_repository.dart';
import '../../domain/budget_model.dart';
import '../../services/budget_calculator_service.dart';

final allBudgetsStreamProvider = StreamProvider<List<BudgetData>>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchAllBudgets();
});

final allCategoriesStreamProvider = StreamProvider<List<CategoryData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.categories).watch();
});

final allTransactionsStreamProvider = StreamProvider<List<TransactionData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.transactions).watch();
});

final budgetProgressListProvider = Provider<List<BudgetProgress>>((ref) {
  final budgetsAsync = ref.watch(allBudgetsStreamProvider);
  final txsAsync = ref.watch(allTransactionsStreamProvider);
  final cardsAsync = ref.watch(cardsStreamProvider);
  final categoriesAsync = ref.watch(allCategoriesStreamProvider);

  final budgets = budgetsAsync.asData?.value ?? [];
  final txs = txsAsync.asData?.value ?? [];
  final cards = cardsAsync.asData?.value ?? [];
  final categories = categoriesAsync.asData?.value ?? [];

  if (budgets.isEmpty) return [];

  return budgets.map((b) {
    return BudgetCalculatorService.calculateProgress(
      budget: b,
      allTransactions: txs,
      cards: cards,
      categories: categories,
    );
  }).toList();
});

final overallBudgetProgressProvider = Provider<BudgetProgress?>((ref) {
  final list = ref.watch(budgetProgressListProvider);
  return list.where((p) => p.scope == BudgetScope.overall).firstOrNull;
});

final activeBudgetAlertsProvider = Provider<List<BudgetAlert>>((ref) {
  final budgetsAsync = ref.watch(allBudgetsStreamProvider);
  final txsAsync = ref.watch(allTransactionsStreamProvider);

  final budgets = budgetsAsync.asData?.value ?? [];
  final txs = txsAsync.asData?.value ?? [];

  return BudgetCalculatorService.evaluateThresholdAlerts(
    budgets: budgets,
    transactions: txs,
  );
});
