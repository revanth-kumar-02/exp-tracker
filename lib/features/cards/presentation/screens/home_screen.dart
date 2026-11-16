import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/security/security_controller.dart';
import '../../../../core/security/security_settings_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../budgets/presentation/controllers/budget_controller.dart';
import '../../../notifications/presentation/widgets/notification_permission_banner.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';
import '../controllers/card_controller.dart';
import '../widgets/quick_actions_grid.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onAddCard;
  final VoidCallback onBudgets;
  final VoidCallback onAnalytics;
  final VoidCallback onCardBills;
  final VoidCallback onViewCards;
  final VoidCallback onViewTransactions;

  const HomeScreen({
    super.key,
    required this.onAddCard,
    required this.onBudgets,
    required this.onAnalytics,
    required this.onCardBills,
    required this.onViewCards,
    required this.onViewTransactions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCardsAsync = ref.watch(cardsStreamProvider);
    final spendingOverviewAsync = ref.watch(dashboardSpendingProvider);
    final overallBudget = ref.watch(overallBudgetProgressProvider);
    final allTxsAsync = ref.watch(allTransactionsStreamProvider);
    final unassignedCountAsync = ref.watch(unassignedTransactionsCountProvider);

    final unassignedCount = unassignedCountAsync.asData?.value ?? 0;
    final allCards = allCardsAsync.asData?.value ?? [];
    final allTxs = allTxsAsync.asData?.value ?? [];

    // Latest 4 transactions sorted descending by timestamp
    final recentTxs = (List.of(allTxs)
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt)))
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Top App Bar (Avatar, App Title, Lock, Notification Bell)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Avatar
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF28283E),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white70, size: 22),
                      ),
                    ),

                    // App Title with Logo Icon
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.bar_chart, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Expense Tracker',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),

                    // Security Lock & Notification Bell
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => SecuritySettingsDialog.show(context),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surfaceBorder, width: 1),
                            ),
                            child: Icon(
                              ref.watch(securityLockProvider).isLockEnabled
                                  ? Icons.lock_outline
                                  : Icons.lock_open_outlined,
                              color: ref.watch(securityLockProvider).isLockEnabled
                                  ? AppColors.accentSuccess
                                  : Colors.white70,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            if (unassignedCount > 0) {
                              ref
                                  .read(transactionTabFilterProvider.notifier)
                                  .setFilter(TransactionTabFilter.needsReview);
                            }
                            onViewTransactions();
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.surfaceBorder, width: 1),
                                ),
                                child: const Center(
                                  child: Icon(Icons.notifications_outlined,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                              if (unassignedCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 7,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: AppColors.redDot,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 2. Greeting Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Good evening 👋', style: AppTypography.displayLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Your monthly financial overview',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const NotificationPermissionBanner(),

              const SizedBox(height: 18),

              // 3. Total Spending Hero Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: spendingOverviewAsync.when(
                  data: (overview) {
                    final delta = overview.monthOverMonthChangePercent;
                    final isDecrease = delta <= 0;
                    final badgeColor = isDecrease ? AppColors.success : AppColors.warning;
                    final icon = isDecrease ? Icons.arrow_downward : Icons.arrow_upward;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.surfaceBorder),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x337C3AED),
                            blurRadius: 18,
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
                                'Total Spent This Month',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: badgeColor.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(icon, color: badgeColor, size: 13),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${delta.abs().toInt()}% vs last month',
                                      style: TextStyle(
                                        color: badgeColor,
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
                            CurrencyFormatter.formatPaise(overview.totalSpentPaise),
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.surfaceBorder, height: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.credit_card,
                                      color: AppColors.primaryLight, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    allCards.isEmpty
                                        ? 'No cards registered'
                                        : '${allCards.length} registered card${allCards.length == 1 ? '' : 's'}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: onViewCards,
                                child: const Row(
                                  children: [
                                    Text(
                                      'Manage Cards',
                                      style: TextStyle(
                                        color: AppColors.primaryLight,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.arrow_forward_ios,
                                        color: AppColors.primaryLight, size: 11),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 150),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Quick Actions Grid (Add Card, Budgets, Analytics, Card Bills)
              QuickActionsGrid(
                onAddCard: onAddCard,
                onBudgets: onBudgets,
                onAnalytics: onAnalytics,
                onCardBills: onCardBills,
              ),

              const SizedBox(height: 28),

              // 5. Budget Overview Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monthly Budget', style: AppTypography.titleMedium),
                        GestureDetector(
                          onTap: onBudgets,
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (overallBudget != null)
                      _BudgetCardSummary(progress: overallBudget, onTap: onBudgets)
                    else
                      _EmptyBudgetCard(onSetBudget: onBudgets),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 6. Recent Transactions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Transactions', style: AppTypography.titleMedium),
                        GestureDetector(
                          onTap: onViewTransactions,
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (recentTxs.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: Center(
                          child: Text(
                            'No transactions recorded yet',
                            style:
                                AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ...recentTxs.map((tx) => _HomeTransactionTile(tx: tx)),
                  ],
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetCardSummary extends StatelessWidget {
  final dynamic progress;
  final VoidCallback onTap;

  const _BudgetCardSummary({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double pct = (progress.percentage as double).clamp(0.0, 1.0);
    final isBreached = progress.isBreached as bool;
    final isWarning = progress.isWarning as bool;

    Color statusColor = AppColors.primaryAccent;
    if (isBreached) {
      statusColor = AppColors.accentError;
    } else if (isWarning) {
      statusColor = AppColors.warning;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progress.name as String,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  '${(pct * 100).round()}% used',
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct == 0 ? 0.05 : pct,
                minHeight: 6,
                backgroundColor: AppColors.progressTrack,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spent: ${CurrencyFormatter.formatPaise(progress.totalSpentPaise as int)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                Text(
                  'Cap: ${CurrencyFormatter.formatPaise(progress.amountLimitPaise as int)}',
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBudgetCard extends StatelessWidget {
  final VoidCallback onSetBudget;

  const _EmptyBudgetCard({required this.onSetBudget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No monthly budget cap set',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 2),
              Text(
                'Set a cap to get spending alert warnings',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: onSetBudget,
            child: const Text('Set Cap',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _HomeTransactionTile extends StatelessWidget {
  final dynamic tx;

  const _HomeTransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, hh:mm a');
    final isCredit = (tx.transactionType as String).toUpperCase() == 'CREDIT';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCredit ? Icons.arrow_downward : Icons.storefront_outlined,
                  size: 16,
                  color: isCredit ? AppColors.success : Colors.white70,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.merchant as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateFormat.format(tx.occurredAt as DateTime),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${isCredit ? '+' : '-'}${CurrencyFormatter.formatPaise(tx.amountPaise as int)}',
            style: TextStyle(
              color: isCredit ? AppColors.success : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
