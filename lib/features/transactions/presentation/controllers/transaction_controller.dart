import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/transaction_repository.dart';

enum TransactionTabFilter { all, needsReview, confirmed }
enum DateRangeFilter { all, thisWeek, thisMonth, lastMonth }

class TransactionTabFilterNotifier extends Notifier<TransactionTabFilter> {
  @override
  TransactionTabFilter build() => TransactionTabFilter.all;

  void setFilter(TransactionTabFilter filter) {
    state = filter;
  }
}

final transactionTabFilterProvider =
    NotifierProvider<TransactionTabFilterNotifier, TransactionTabFilter>(
  TransactionTabFilterNotifier.new,
);

class SelectedCardFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCardId(String? id) {
    state = id;
  }
}

final selectedCardFilterProvider =
    NotifierProvider<SelectedCardFilterNotifier, String?>(
  SelectedCardFilterNotifier.new,
);

class TransactionSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String q) {
    state = q;
  }
}

final transactionSearchQueryProvider =
    NotifierProvider<TransactionSearchQueryNotifier, String>(
  TransactionSearchQueryNotifier.new,
);

class DateRangeFilterNotifier extends Notifier<DateRangeFilter> {
  @override
  DateRangeFilter build() => DateRangeFilter.all;

  void setRange(DateRangeFilter range) {
    state = range;
  }
}

final dateRangeFilterProvider =
    NotifierProvider<DateRangeFilterNotifier, DateRangeFilter>(
  DateRangeFilterNotifier.new,
);

final unassignedTransactionsCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchUnassignedCount();
});

final rawTransactionsListStreamProvider = StreamProvider<List<TransactionData>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  final tab = ref.watch(transactionTabFilterProvider);
  final cardId = ref.watch(selectedCardFilterProvider);

  String? matchStatus;
  if (tab == TransactionTabFilter.needsReview) {
    matchStatus = 'UNASSIGNED';
  } else if (tab == TransactionTabFilter.confirmed) {
    matchStatus = 'CONFIRMED';
  }

  return repo.watchTransactions(
    cardId: cardId,
    matchStatus: matchStatus,
  );
});

final transactionsListStreamProvider = Provider<AsyncValue<List<TransactionData>>>((ref) {
  final rawAsync = ref.watch(rawTransactionsListStreamProvider);
  final query = ref.watch(transactionSearchQueryProvider).trim().toLowerCase();
  final dateRange = ref.watch(dateRangeFilterProvider);

  return rawAsync.whenData((list) {
    var filtered = list;

    // 1. Text Search Filter (Merchant / Description)
    if (query.isNotEmpty) {
      filtered = filtered.where((tx) {
        final m = tx.merchant.toLowerCase();
        final d = tx.description?.toLowerCase() ?? '';
        return m.contains(query) || d.contains(query);
      }).toList();
    }

    // 2. Date Range Filter
    if (dateRange != DateRangeFilter.all) {
      final now = DateTime.now();
      DateTime startDate;
      DateTime? endDate;

      switch (dateRange) {
        case DateRangeFilter.thisWeek:
          startDate = now.subtract(const Duration(days: 7));
          break;
        case DateRangeFilter.thisMonth:
          startDate = DateTime(now.year, now.month, 1);
          break;
        case DateRangeFilter.lastMonth:
          startDate = DateTime(now.year, now.month - 1, 1);
          endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
          break;
        case DateRangeFilter.all:
          startDate = DateTime(1970);
          break;
      }

      filtered = filtered.where((tx) {
        if (endDate != null) {
          return tx.occurredAt.isAfter(startDate) && tx.occurredAt.isBefore(endDate);
        }
        return tx.occurredAt.isAfter(startDate);
      }).toList();
    }

    return filtered;
  });
});
