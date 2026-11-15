import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PaymentCards, Categories, Transactions, Budgets, NotificationSources])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'expense_tracker');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed default categories
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: 'cat_food',
          name: 'Food & Dining',
          icon: 'fastfood',
          colorHex: '#F59E0B',
          isCustom: const Value(false),
        ),
      );
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: 'cat_shopping',
          name: 'Shopping',
          icon: 'shopping_bag',
          colorHex: '#8B5CF6',
          isCustom: const Value(false),
        ),
      );
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: 'cat_travel',
          name: 'Travel & Commute',
          icon: 'directions_car',
          colorHex: '#3B82F6',
          isCustom: const Value(false),
        ),
      );
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: 'cat_bills',
          name: 'Bills & Utilities',
          icon: 'receipt_long',
          colorHex: '#EF4444',
          isCustom: const Value(false),
        ),
      );
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: 'cat_fuel',
          name: 'Fuel',
          icon: 'local_gas_station',
          colorHex: '#10B981',
          isCustom: const Value(false),
        ),
      );
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: 'cat_other',
          name: 'Other',
          icon: 'more_horiz',
          colorHex: '#64748B',
          isCustom: const Value(false),
        ),
      );
    },
  );
}
