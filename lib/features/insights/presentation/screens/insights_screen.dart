import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../controllers/insights_controller.dart';
import '../../domain/insights_model.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(insightsDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Insights & Analytics', style: AppTypography.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Total Monthly Spend Hero Card
              _MonthlyOverviewCard(insights: insights),
              const SizedBox(height: 24),

              // 2. Spending by Category Section
              const Text('Spending by Category', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              _CategoryBreakdownCard(breakdown: insights.categoryBreakdown, totalSpentPaise: insights.totalSpentPaise),
              const SizedBox(height: 24),

              // 3. Debit vs Credit Split
              const Text('Payment Method Split', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              _DebitVsCreditCard(comparison: insights.cardTypeComparison),
              const SizedBox(height: 24),

              // 4. Top Merchants Section
              const Text('Top Merchants', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              _TopMerchantsCard(merchants: insights.topMerchants),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyOverviewCard extends StatelessWidget {
  final InsightsData insights;

  const _MonthlyOverviewCard({required this.insights});

  @override
  Widget build(BuildContext context) {
    final delta = insights.monthOverMonthChangePercent;
    final isDecrease = delta <= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x337C3AED),
            blurRadius: 16,
            offset: Offset(0, 6),
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
                'This Month Spending',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDecrease ? AppColors.success : AppColors.warning).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDecrease ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isDecrease ? AppColors.success : AppColors.warning,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${delta.abs().toInt()}% vs last month',
                      style: TextStyle(
                        color: isDecrease ? AppColors.success : AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatPaise(insights.totalSpentPaise),
            style: AppTypography.displayLarge.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '${insights.totalTransactionsCount} transactions recorded',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  final List<CategorySpending> breakdown;
  final int totalSpentPaise;

  const _CategoryBreakdownCard({
    required this.breakdown,
    required this.totalSpentPaise,
  });

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: const Center(
          child: Text(
            'No categorized expenses yet this month',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          // Segmented progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: breakdown.map((cat) {
                  return Expanded(
                    flex: (cat.percentage * 100).clamp(1, 100).toInt(),
                    child: Container(color: _parseHexColor(cat.colorHex)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Category items
          ...breakdown.map((cat) {
            final color = _parseHexColor(cat.colorHex);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.categoryName,
                          style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${cat.transactionCount} transaction${cat.transactionCount > 1 ? 's' : ''}',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.formatPaise(cat.spentPaise),
                        style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${cat.percentageInt}%',
                        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _parseHexColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
}

class _DebitVsCreditCard extends StatelessWidget {
  final CardTypeComparison comparison;

  const _DebitVsCreditCard({required this.comparison});

  @override
  Widget build(BuildContext context) {
    final debitPct = (comparison.debitPercentage * 100).round();
    final creditPct = (comparison.creditPercentage * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MethodStat(
                label: 'Debit Cards',
                amountPaise: comparison.debitSpentPaise,
                count: comparison.debitCount,
                color: AppColors.primaryLight,
                percentage: debitPct,
              ),
              _MethodStat(
                label: 'Credit Cards',
                amountPaise: comparison.creditSpentPaise,
                count: comparison.creditCount,
                color: const Color(0xFF3B82F6),
                percentage: creditPct,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: debitPct == 0 && creditPct == 0 ? 50 : debitPct,
                    child: Container(color: AppColors.primaryLight),
                  ),
                  Expanded(
                    flex: debitPct == 0 && creditPct == 0 ? 50 : creditPct,
                    child: Container(color: const Color(0xFF3B82F6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodStat extends StatelessWidget {
  final String label;
  final int amountPaise;
  final int count;
  final Color color;
  final int percentage;

  const _MethodStat({
    required this.label,
    required this.amountPaise,
    required this.count,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            Text('$percentage%', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.formatPaise(amountPaise),
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        Text('$count txs', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _TopMerchantsCard extends StatelessWidget {
  final List<TopMerchant> merchants;

  const _TopMerchantsCard({required this.merchants});

  @override
  Widget build(BuildContext context) {
    if (merchants.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: const Center(
          child: Text('No merchant transactions yet', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: merchants.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final m = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.merchant, style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      Text('${m.transactionCount} transactions', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormatter.formatPaise(m.spentPaise),
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
