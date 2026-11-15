import 'package:drift/drift.dart';

@DataClassName('PaymentCardData')
class PaymentCards extends Table {
  TextColumn get id => text()();
  TextColumn get bankName => text().withLength(min: 1, max: 100)();
  TextColumn get cardType => text()(); // 'DEBIT' or 'CREDIT'
  TextColumn get nickname => text().nullable().withLength(max: 100)();
  TextColumn get network => text()(); // 'VISA', 'MASTERCARD', 'RUPAY', etc.
  TextColumn get maskedNumber => text()(); // '•••• •••• •••• 4821'
  TextColumn get lastFour => text().withLength(min: 4, max: 4)();
  TextColumn get cardholderName => text().nullable()();
  TextColumn get expiryMonthYear => text().nullable()(); // 'MM/YY'
  IntColumn get colorGradientIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryData')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text()(); // Icon identifier
  TextColumn get colorHex => text()(); // Hex string e.g. '#8B5CF6'
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionData')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get paymentCardId => text()
      .nullable()
      .customConstraint('NULL REFERENCES payment_cards(id) ON DELETE SET NULL')();
  TextColumn get categoryId => text()
      .nullable()
      .customConstraint('NULL REFERENCES categories(id) ON DELETE SET NULL')();
  IntColumn get amountPaise => integer()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get merchant => text()();
  TextColumn get description => text().nullable()();
  TextColumn get transactionType =>
      text().withDefault(const Constant('DEBIT'))(); // DEBIT, CREDIT, REFUND, etc.
  TextColumn get matchStatus =>
      text().withDefault(const Constant('CONFIRMED'))(); // CONFIRMED, UNASSIGNED, MANUAL
  TextColumn get dedupeFingerprint => text().unique()();
  TextColumn get sourceApp => text()();
  TextColumn get rawNotificationText => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BudgetData')
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get period => text().withDefault(const Constant('MONTHLY'))();
  IntColumn get amountLimitPaise => integer()();
  TextColumn get scopeType =>
      text().withDefault(const Constant('OVERALL'))(); // OVERALL, CARD, CATEGORY
  TextColumn get scopeId => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NotificationSourceData')
class NotificationSources extends Table {
  TextColumn get packageName => text()();
  TextColumn get displayName => text()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get parserVersion => text().withDefault(const Constant('1.0.0'))();
  DateTimeColumn get lastProcessedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {packageName};
}
