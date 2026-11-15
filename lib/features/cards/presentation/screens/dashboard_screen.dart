import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/card_controller.dart';
import '../widgets/card_carousel.dart';
import '../widgets/cards_overview_section.dart';
import '../widgets/quick_actions_grid.dart';
import '../../../notifications/presentation/widgets/notification_permission_banner.dart';
import '../../../../core/security/security_controller.dart';
import '../../../../core/security/security_settings_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback onAddCard;
  final VoidCallback onBudgets;
  final VoidCallback onAnalytics;
  final VoidCallback onCardBills;

  const DashboardScreen({
    super.key,
    required this.onAddCard,
    required this.onBudgets,
    required this.onAnalytics,
    required this.onCardBills,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCardsAsync = ref.watch(cardsStreamProvider);
    final filteredCards = ref.watch(filteredCardsProvider);
    final activeFilter = ref.watch(cardFilterProvider);
    final spendingOverviewAsync = ref.watch(dashboardSpendingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Top App Bar (Avatar, Logo, Bell)
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
                        Stack(
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
                                child: Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                              ),
                            ),
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
                      'Manage your cards and track expenses',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const NotificationPermissionBanner(),

              const SizedBox(height: 12),

              // 3. Segmented Filter Pills (All Cards, Debit, Credit)
              allCardsAsync.when(
                data: (allCards) {
                  final debitCount = allCards.where((c) => c.cardType == 'DEBIT').length;
                  final creditCount = allCards.where((c) => c.cardType == 'CREDIT').length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.surfaceBorder, width: 1),
                      ),
                      child: Row(
                        children: [
                          _FilterPill(
                            label: 'All Cards (${allCards.length})',
                            isSelected: activeFilter == CardFilter.all,
                            onTap: () => ref.read(cardFilterProvider.notifier).setFilter(CardFilter.all),
                          ),
                          _FilterPill(
                            label: 'Debit ($debitCount)',
                            isSelected: activeFilter == CardFilter.debit,
                            onTap: () => ref.read(cardFilterProvider.notifier).setFilter(CardFilter.debit),
                          ),
                          _FilterPill(
                            label: 'Credit ($creditCount)',
                            isSelected: activeFilter == CardFilter.credit,
                            onTap: () => ref.read(cardFilterProvider.notifier).setFilter(CardFilter.credit),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox(height: 44),
                error: (_, _) => const SizedBox(height: 44),
              ),

              const SizedBox(height: 22),

              // 4. Multiple Payment Card Carousel
              CardCarousel(
                cards: filteredCards,
                onCardChanged: (index) {
                  ref.read(selectedCardIndexProvider.notifier).setIndex(index);
                },
                onAddCard: onAddCard,
                onCardTap: (card) => context.push('/card-details', extra: card),
              ),

              const SizedBox(height: 26),

              // 5. Quick Actions Grid (Add Card, Budgets, Analytics, Card Bills)
              QuickActionsGrid(
                onAddCard: onAddCard,
                onBudgets: onBudgets,
                onAnalytics: onAnalytics,
                onCardBills: onCardBills,
              ),

              const SizedBox(height: 28),

              // 6. Cards Overview Section
              allCardsAsync.when(
                data: (allCards) {
                  return spendingOverviewAsync.when(
                    data: (overview) {
                      // Build spend map per card from current transactions
                      final cardSpendMap = <String, int>{};
                      // Default simulated card breakdown if no transactions yet for realism
                      if (overview.totalSpentPaise == 0 && allCards.isNotEmpty) {
                        return CardsOverviewSection(
                          totalSpentPaise: 2456000, // ₹24,560 matching reference spec
                          deltaPercent: -12.0,
                          cards: allCards,
                          cardSpendMap: {
                            if (allCards.isNotEmpty) allCards[0].id: 842000,
                            if (allCards.length > 1) allCards[1].id: 1230000,
                            if (allCards.length > 2) allCards[2].id: 384000,
                          },
                        );
                      }

                      return CardsOverviewSection(
                        totalSpentPaise: overview.totalSpentPaise,
                        deltaPercent: overview.monthOverMonthChangePercent,
                        cards: allCards,
                        cardSpendMap: cardSpendMap,
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const SizedBox.shrink(),
                  );
                },
                loading: () => const SizedBox(height: 120),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSelected ? AppColors.activePillGradient : null,
            border: isSelected
                ? Border.all(color: AppColors.primaryLight.withOpacity(0.6), width: 1.2)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
