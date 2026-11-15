import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../cards/presentation/controllers/card_controller.dart';
import '../../data/budget_repository.dart';
import '../../domain/budget_model.dart';
import '../../services/budget_calculator_service.dart';
import '../controllers/budget_controller.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressList = ref.watch(budgetProgressListProvider);
    final overallProgress = ref.watch(overallBudgetProgressProvider);
    final alerts = ref.watch(activeBudgetAlertsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budgets & Limits', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryAccent),
            tooltip: 'Create Budget',
            onPressed: () => _showCreateBudgetSheet(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Threshold Alerts Banner (if any)
              if (alerts.isNotEmpty) ...[
                ...alerts.map((a) => _AlertCard(alert: a)),
                const SizedBox(height: 16),
              ],

              // 2. Overall Monthly Budget Card
              if (overallProgress != null)
                _OverallBudgetCard(progress: overallProgress)
              else
                _EmptyOverallBudgetCard(onSetBudget: () => _showCreateBudgetSheet(context, ref, defaultScope: BudgetScope.overall)),

              const SizedBox(height: 28),

              // 3. Card-wise Budgets Section
              _buildSectionHeader('Card Budgets', onAdd: () {
                _showCreateBudgetSheet(context, ref, defaultScope: BudgetScope.card);
              }),
              const SizedBox(height: 12),
              ..._buildScopedBudgets(
                progressList.where((p) => p.scope == BudgetScope.card).toList(),
                emptyText: 'No card-specific spending caps configured.',
                onAdd: () => _showCreateBudgetSheet(context, ref, defaultScope: BudgetScope.card),
              ),

              const SizedBox(height: 28),

              // 4. Category-wise Budgets Section
              _buildSectionHeader('Category Budgets', onAdd: () {
                _showCreateBudgetSheet(context, ref, defaultScope: BudgetScope.category);
              }),
              const SizedBox(height: 12),
              ..._buildScopedBudgets(
                progressList.where((p) => p.scope == BudgetScope.category).toList(),
                emptyText: 'No category spending limits configured.',
                onAdd: () => _showCreateBudgetSheet(context, ref, defaultScope: BudgetScope.category),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.titleMedium),
        GestureDetector(
          onTap: onAdd,
          child: const Text(
            '+ Add Limit',
            style: TextStyle(
              color: AppColors.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildScopedBudgets(
    List<BudgetProgress> items, {
    required String emptyText,
    required VoidCallback onAdd,
  }) {
    if (items.isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceBorder, width: 1),
          ),
          child: Center(
            child: Text(
              emptyText,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
            ),
          ),
        ),
      ];
    }

    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _BudgetProgressRowCard(progress: item),
    )).toList();
  }

  void _showCreateBudgetSheet(
    BuildContext context,
    WidgetRef ref, {
    BudgetScope defaultScope = BudgetScope.overall,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreateBudgetSheet(defaultScope: defaultScope),
    );
  }
}

// Overall Monthly Spend Card
class _OverallBudgetCard extends StatelessWidget {
  final BudgetProgress progress;

  const _OverallBudgetCard({required this.progress});

  Color get _statusColor {
    switch (progress.status) {
      case BudgetThresholdStatus.safe:
        return AppColors.primaryLight;
      case BudgetThresholdStatus.warning:
        return AppColors.warning;
      case BudgetThresholdStatus.exceeded:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOver = progress.remainingPaise < 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Monthly Budget',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${progress.percentageInt}% Spent',
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Big Remaining Balance
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                CurrencyFormatter.formatPaise(progress.remainingPaise.abs()),
                style: AppTypography.displayLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isOver ? AppColors.error : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isOver ? 'over budget' : 'left of ${CurrencyFormatter.formatPaise(progress.limitPaise)}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Glowing Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.percentage > 1.0 ? 1.0 : progress.percentage,
              minHeight: 8,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ),
          const SizedBox(height: 20),

          // Statistics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricPill(
                label: 'Spent so far',
                value: CurrencyFormatter.formatPaise(progress.spentPaise),
              ),
              _MetricPill(
                label: 'Days left',
                value: '${progress.daysRemaining} days',
              ),
              _MetricPill(
                label: 'Recommended',
                value: '${CurrencyFormatter.formatPaise(progress.dailyAllowancePaise)}/day',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// Scoped Budget Row Card
class _BudgetProgressRowCard extends StatelessWidget {
  final BudgetProgress progress;

  const _BudgetProgressRowCard({required this.progress});

  Color get _statusColor {
    switch (progress.status) {
      case BudgetThresholdStatus.safe:
        return AppColors.primaryLight;
      case BudgetThresholdStatus.warning:
        return AppColors.warning;
      case BudgetThresholdStatus.exceeded:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progress.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${CurrencyFormatter.formatPaise(progress.spentPaise)} / ${CurrencyFormatter.formatPaise(progress.limitPaise)}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.percentage > 1.0 ? 1.0 : progress.percentage,
              minHeight: 6,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progress.remainingPaise >= 0
                    ? '${CurrencyFormatter.formatPaise(progress.remainingPaise)} remaining'
                    : '${CurrencyFormatter.formatPaise(progress.remainingPaise.abs())} exceeded',
                style: TextStyle(
                  fontSize: 12,
                  color: progress.remainingPaise >= 0 ? AppColors.textMuted : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${progress.percentageInt}%',
                style: TextStyle(
                  fontSize: 12,
                  color: _statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Alert Card
class _AlertCard extends StatelessWidget {
  final BudgetAlert alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert.isSevere ? AppColors.error : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(alert.isSevere ? Icons.error_outline : Icons.warning_amber_rounded, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert.message,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOverallBudgetCard extends StatelessWidget {
  final VoidCallback onSetBudget;

  const _EmptyOverallBudgetCard({required this.onSetBudget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSetBudget,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.primaryLight.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGlow,
              ),
              child: const Icon(Icons.add, color: AppColors.primaryAccent, size: 24),
            ),
            const SizedBox(height: 12),
            const Text(
              'Set Monthly Spending Budget',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Define a monthly limit to monitor live spending progress and alerts',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// Create Budget Sheet Modal
class _CreateBudgetSheet extends ConsumerStatefulWidget {
  final BudgetScope defaultScope;

  const _CreateBudgetSheet({required this.defaultScope});

  @override
  ConsumerState<_CreateBudgetSheet> createState() => _CreateBudgetSheetState();
}

class _CreateBudgetSheetState extends ConsumerState<_CreateBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  late BudgetScope _selectedScope;
  String? _selectedScopeId;

  @override
  void initState() {
    super.initState();
    _selectedScope = widget.defaultScope;
    if (_selectedScope == BudgetScope.overall) {
      _nameController.text = 'Monthly Spending Limit';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final amountPaise = CurrencyFormatter.parseToPaise(_amountController.text.trim());
    final repo = ref.read(budgetRepositoryProvider);

    await repo.setBudget(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      period: BudgetPeriod.monthly,
      amountLimitPaise: amountPaise,
      scopeType: _selectedScope,
      scopeId: _selectedScopeId,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget limit saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsStreamProvider);
    final categoriesAsync = ref.watch(allCategoriesStreamProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Set Budget Limit', style: AppTypography.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Scope Selector
              const Text('Budget Scope', style: AppTypography.bodySmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<BudgetScope>(
                value: _selectedScope,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.tune)),
                dropdownColor: AppColors.surface,
                items: BudgetScope.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s.displayName, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedScope = val;
                      _selectedScopeId = null;
                      if (_selectedScope == BudgetScope.overall) {
                        _nameController.text = 'Monthly Spending Limit';
                      } else {
                        _nameController.clear();
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Card / Category Dropdown depending on Scope
              if (_selectedScope == BudgetScope.card) ...[
                const Text('Select Card', style: AppTypography.bodySmall),
                const SizedBox(height: 8),
                cardsAsync.when(
                  data: (cards) => DropdownButtonFormField<String>(
                    value: _selectedScopeId,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.credit_card)),
                    dropdownColor: AppColors.surface,
                    hint: const Text('Choose card'),
                    items: cards.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.bankName} ••${c.lastFour} (${c.cardType})', style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedScopeId = val;
                        final card = cards.firstWhere((c) => c.id == val);
                        _nameController.text = '${card.bankName} ••${card.lastFour} Limit';
                      });
                    },
                    validator: (val) => val == null ? 'Please select a card' : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
              ] else if (_selectedScope == BudgetScope.category) ...[
                const Text('Select Category', style: AppTypography.bodySmall),
                const SizedBox(height: 8),
                categoriesAsync.when(
                  data: (categories) => DropdownButtonFormField<String>(
                    value: _selectedScopeId,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.category)),
                    dropdownColor: AppColors.surface,
                    hint: const Text('Choose category'),
                    items: categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedScopeId = val;
                        final cat = categories.firstWhere((c) => c.id == val);
                        _nameController.text = '${cat.name} Budget';
                      });
                    },
                    validator: (val) => val == null ? 'Please select a category' : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
              ],

              // Budget Name
              const Text('Budget Name', style: AppTypography.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Monthly Limit, Dining Cap',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // Limit Amount
              const Text('Amount Limit (₹)', style: AppTypography.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'e.g. 50000',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter an amount';
                  final num = int.tryParse(val.trim());
                  if (num == null || num <= 0) return 'Please enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Save Budget',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
