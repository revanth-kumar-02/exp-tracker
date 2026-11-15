import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../cards/data/card_repository.dart';
import '../domain/budget_model.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BudgetRepository(db);
});

class BudgetRepository {
  final AppDatabase _db;

  BudgetRepository(this._db);

  Stream<List<BudgetData>> watchAllBudgets() {
    return (_db.select(_db.budgets)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<List<BudgetData>> getAllBudgets() {
    return (_db.select(_db.budgets)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> setBudget({
    required String id,
    required String name,
    required BudgetPeriod period,
    required int amountLimitPaise,
    required BudgetScope scopeType,
    String? scopeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _db.into(_db.budgets).insert(
      BudgetsCompanion.insert(
        id: id,
        name: name,
        period: Value(period.dbValue),
        amountLimitPaise: amountLimitPaise,
        scopeType: Value(scopeType.dbValue),
        scopeId: Value(scopeId),
        startDate: Value(startDate),
        endDate: Value(endDate),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> deleteBudget(String id) async {
    await (_db.delete(_db.budgets)..where((t) => t.id.equals(id))).go();
  }
}
