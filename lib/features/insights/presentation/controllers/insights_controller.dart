import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../cards/presentation/controllers/card_controller.dart';
import '../../../budgets/presentation/controllers/budget_controller.dart';
import '../../domain/insights_model.dart';
import '../../services/insights_service.dart';

final insightsDataProvider = Provider<InsightsData>((ref) {
  final txsAsync = ref.watch(allTransactionsStreamProvider);
  final categoriesAsync = ref.watch(allCategoriesStreamProvider);
  final cardsAsync = ref.watch(cardsStreamProvider);

  final txs = txsAsync.asData?.value ?? <TransactionData>[];
  final categories = categoriesAsync.asData?.value ?? <CategoryData>[];
  final cards = cardsAsync.asData?.value ?? <PaymentCardData>[];

  return InsightsService.calculateInsights(
    transactions: txs,
    categories: categories,
    cards: cards,
  );
});
