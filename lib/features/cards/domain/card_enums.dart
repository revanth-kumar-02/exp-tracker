enum CardType {
  debit('Debit Card', 'DEBIT'),
  credit('Credit Card', 'CREDIT');

  final String displayName;
  final String dbValue;

  const CardType(this.displayName, this.dbValue);

  static CardType fromString(String val) {
    if (val.toUpperCase() == 'CREDIT') return CardType.credit;
    return CardType.debit;
  }
}

enum CardNetwork {
  visa('VISA'),
  mastercard('Mastercard'),
  rupay('RuPay'),
  amex('AMEX'),
  other('CARD');

  final String displayName;

  const CardNetwork(this.displayName);

  static CardNetwork fromNumber(String number) {
    final clean = number.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('4')) return CardNetwork.visa;
    if (clean.startsWith(RegExp(r'^5[1-5]')) || clean.startsWith(RegExp(r'^2[2-7]'))) {
      return CardNetwork.mastercard;
    }
    if (clean.startsWith(RegExp(r'^(60|65|81|82|508)'))) return CardNetwork.rupay;
    if (clean.startsWith(RegExp(r'^3[47]'))) return CardNetwork.amex;
    return CardNetwork.visa; // Default fintech look
  }

  static CardNetwork fromString(String val) {
    final upper = val.toUpperCase();
    for (final net in CardNetwork.values) {
      if (net.name.toUpperCase() == upper || net.displayName.toUpperCase() == upper) {
        return net;
      }
    }
    return CardNetwork.visa;
  }
}
