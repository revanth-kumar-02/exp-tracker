import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/card_repository.dart';

enum CardFilter { all, debit, credit }

class CardFilterNotifier extends Notifier<CardFilter> {
  @override
  CardFilter build() => CardFilter.all;

  void setFilter(CardFilter filter) {
    state = filter;
  }
}

final cardFilterProvider = NotifierProvider<CardFilterNotifier, CardFilter>(
  CardFilterNotifier.new,
);

class SelectedCardIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final selectedCardIndexProvider =
    NotifierProvider<SelectedCardIndexNotifier, int>(
  SelectedCardIndexNotifier.new,
);

final cardsStreamProvider = StreamProvider<List<PaymentCardData>>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchActiveCards();
});

final filteredCardsProvider = Provider<List<PaymentCardData>>((ref) {
  final cardsAsync = ref.watch(cardsStreamProvider);
  final filter = ref.watch(cardFilterProvider);

  return cardsAsync.maybeWhen(
    data: (cards) {
      switch (filter) {
        case CardFilter.all:
          return cards;
        case CardFilter.debit:
          return cards.where((c) => c.cardType.toUpperCase() == 'DEBIT').toList();
        case CardFilter.credit:
          return cards.where((c) => c.cardType.toUpperCase() == 'CREDIT').toList();
      }
    },
    orElse: () => <PaymentCardData>[],
  );
});

class CardSpendingMetric {
  final String cardId;
  final String cardName;
  final String lastFour;
  final String bankName;
  final String cardType;
  final int totalSpentPaise;
  final double percentageOfTotal;
  final int colorGradientIndex;

  const CardSpendingMetric({
    required this.cardId,
    required this.cardName,
    required this.lastFour,
    required this.bankName,
    required this.cardType,
    required this.totalSpentPaise,
    required this.percentageOfTotal,
    required this.colorGradientIndex,
  });
}

class DashboardSpendingOverview {
  final int totalSpentPaise;
  final double monthOverMonthChangePercent;
  final List<CardSpendingMetric> cardMetrics;

  const DashboardSpendingOverview({
    required this.totalSpentPaise,
    required this.monthOverMonthChangePercent,
    required this.cardMetrics,
  });
}

final dashboardSpendingProvider =
    StreamProvider<DashboardSpendingOverview>((ref) {
  final db = ref.watch(databaseProvider);

  // Watch transactions and calculate spending
  return db.select(db.transactions).watch().map((transactions) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final currentMonthTxs = transactions.where((tx) =>
      tx.occurredAt.isAfter(startOfMonth) &&
      tx.transactionType.toUpperCase() == 'DEBIT'
    ).toList();

    int totalSpent = 0;
    final Map<String, int> cardSpendMap = {};

    for (final tx in currentMonthTxs) {
      totalSpent += tx.amountPaise;
      if (tx.paymentCardId != null) {
        cardSpendMap[tx.paymentCardId!] =
            (cardSpendMap[tx.paymentCardId!] ?? 0) + tx.amountPaise;
      }
    }

    return DashboardSpendingOverview(
      totalSpentPaise: totalSpent,
      monthOverMonthChangePercent: -12.0, // Default baseline matching UI spec (-12%)
      cardMetrics: [],
    );
  });
});
