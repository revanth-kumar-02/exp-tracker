import '../../../core/database/app_database.dart';

class CardBill {
  final PaymentCardData card;
  final int statementDay; // e.g. 15
  final int dueDay; // e.g. 5
  final DateTime statementDate;
  final DateTime dueDate;
  final int totalDuePaise;
  final bool isPaid;
  final int daysRemaining;

  const CardBill({
    required this.card,
    required this.statementDay,
    required this.dueDay,
    required this.statementDate,
    required this.dueDate,
    required this.totalDuePaise,
    required this.isPaid,
    required this.daysRemaining,
  });

  bool get isOverdue => !isPaid && daysRemaining < 0;
  bool get isDueSoon => !isPaid && daysRemaining >= 0 && daysRemaining <= 3;
}
