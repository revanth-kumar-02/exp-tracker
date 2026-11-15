import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../budgets/presentation/controllers/budget_controller.dart';
import '../../domain/card_bill_model.dart';
import 'card_controller.dart';

class PaidBillsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void togglePaid(String cardId) {
    if (state.contains(cardId)) {
      state = Set.from(state)..remove(cardId);
    } else {
      state = Set.from(state)..add(cardId);
    }
  }

  void markPaid(String cardId) {
    state = Set.from(state)..add(cardId);
  }

  void markUnpaid(String cardId) {
    state = Set.from(state)..remove(cardId);
  }
}

final paidBillsProvider = NotifierProvider<PaidBillsNotifier, Set<String>>(
  PaidBillsNotifier.new,
);

final cardBillsProvider = Provider<List<CardBill>>((ref) {
  final cardsAsync = ref.watch(cardsStreamProvider);
  final txsAsync = ref.watch(allTransactionsStreamProvider);
  final paidCardIds = ref.watch(paidBillsProvider);

  final cards = cardsAsync.asData?.value ?? <PaymentCardData>[];
  final txs = txsAsync.asData?.value ?? <TransactionData>[];

  // Only consider credit cards for bills
  final creditCards = cards.where((c) => c.cardType.toUpperCase() == 'CREDIT').toList();

  final now = DateTime.now();
  final List<CardBill> bills = [];

  for (final card in creditCards) {
    // Default statement cycle: 15th to 15th, due on 5th
    const int statementDay = 15;
    const int dueDay = 5;

    DateTime statementDate;
    DateTime dueDate;

    if (now.day >= statementDay) {
      statementDate = DateTime(now.year, now.month, statementDay);
      // Due next month on the 5th
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      dueDate = DateTime(nextYear, nextMonth, dueDay);
    } else {
      // Previous month statement
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final prevYear = now.month == 1 ? now.year - 1 : now.year;
      statementDate = DateTime(prevYear, prevMonth, statementDay);
      dueDate = DateTime(now.year, now.month, dueDay);
    }

    final cycleStartDate = DateTime(statementDate.year, statementDate.month - 1, statementDay);

    // Calculate sum of debits in this cycle for this card
    int totalSpendPaise = 0;
    for (final tx in txs) {
      if (tx.paymentCardId == card.id && tx.transactionType.toUpperCase() == 'DEBIT') {
        if (tx.occurredAt.isAfter(cycleStartDate) && tx.occurredAt.isBefore(statementDate.add(const Duration(days: 1)))) {
          totalSpendPaise += tx.amountPaise;
        }
      }
    }

    // If no transactions in old cycle, take current month spend
    if (totalSpendPaise == 0) {
      for (final tx in txs) {
        if (tx.paymentCardId == card.id && tx.transactionType.toUpperCase() == 'DEBIT') {
          totalSpendPaise += tx.amountPaise;
        }
      }
    }

    final difference = dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    final isPaid = paidCardIds.contains(card.id);

    bills.add(CardBill(
      card: card,
      statementDay: statementDay,
      dueDay: dueDay,
      statementDate: statementDate,
      dueDate: dueDate,
      totalDuePaise: totalSpendPaise,
      isPaid: isPaid,
      daysRemaining: difference,
    ));
  }

  // Sort: unpaid overdue first, then unpaid due soon, then paid
  bills.sort((a, b) {
    if (a.isPaid != b.isPaid) {
      return a.isPaid ? 1 : -1;
    }
    return a.daysRemaining.compareTo(b.daysRemaining);
  });

  return bills;
});
