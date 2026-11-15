enum ParsedTransactionType {
  debit('DEBIT'),
  credit('CREDIT'),
  refund('REFUND'),
  reversal('REVERSAL'),
  failed('FAILED'),
  pending('PENDING');

  final String dbValue;
  const ParsedTransactionType(this.dbValue);
}

class ParsedTransaction {
  final int amountPaise;
  final String currency;
  final String merchant;
  final String? cardSuffix; // Last 4 digits
  final ParsedTransactionType type;
  final DateTime occurredAt;
  final String rawText;
  final String sourceApp;

  const ParsedTransaction({
    required this.amountPaise,
    this.currency = 'INR',
    required this.merchant,
    this.cardSuffix,
    required this.type,
    required this.occurredAt,
    required this.rawText,
    required this.sourceApp,
  });

  bool get isCompletedExpense => type == ParsedTransactionType.debit;
  bool get hasCardSuffix => cardSuffix != null && cardSuffix!.length == 4;
}
