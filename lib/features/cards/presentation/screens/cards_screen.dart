import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/card_controller.dart';
import '../widgets/card_carousel.dart';
import '../widgets/cards_overview_section.dart';

class CardsScreen extends ConsumerWidget {
  final VoidCallback onAddCard;

  const CardsScreen({
    super.key,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCardsAsync = ref.watch(cardsStreamProvider);
    final filteredCards = ref.watch(filteredCardsProvider);
    final activeFilter = ref.watch(cardFilterProvider);
    final spendingOverviewAsync = ref.watch(dashboardSpendingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Cards', style: AppTypography.titleLarge),
            allCardsAsync.maybeWhen(
              data: (cards) => Text(
                cards.isEmpty
                    ? 'No cards registered'
                    : '${cards.length} active card${cards.length == 1 ? '' : 's'} managed',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryAccent),
            tooltip: 'Add New Card',
            onPressed: onAddCard,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Segmented Filter Pills (All Cards, Debit, Credit)
              allCardsAsync.when(
                data: (allCards) {
                  final debitCount =
                      allCards.where((c) => c.cardType.toUpperCase() == 'DEBIT').length;
                  final creditCount =
                      allCards.where((c) => c.cardType.toUpperCase() == 'CREDIT').length;

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
                            onTap: () =>
                                ref.read(cardFilterProvider.notifier).setFilter(CardFilter.all),
                          ),
                          _FilterPill(
                            label: 'Debit ($debitCount)',
                            isSelected: activeFilter == CardFilter.debit,
                            onTap: () =>
                                ref.read(cardFilterProvider.notifier).setFilter(CardFilter.debit),
                          ),
                          _FilterPill(
                            label: 'Credit ($creditCount)',
                            isSelected: activeFilter == CardFilter.credit,
                            onTap: () =>
                                ref.read(cardFilterProvider.notifier).setFilter(CardFilter.credit),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox(height: 44),
                error: (_, _) => const SizedBox(height: 44),
              ),

              const SizedBox(height: 20),

              // 2. Card Carousel
              CardCarousel(
                cards: filteredCards,
                onCardChanged: (index) {
                  ref.read(selectedCardIndexProvider.notifier).setIndex(index);
                },
                onAddCard: onAddCard,
                onCardTap: (card) => context.push('/card-details', extra: card),
              ),

              if (filteredCards.isNotEmpty) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Tap card to view statement, manage status, or edit details',
                    style: TextStyle(
                      color: AppColors.textMuted.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 26),

              // 3. Cards Overview Section (Spending breakdown per card)
              allCardsAsync.when(
                data: (allCards) {
                  return spendingOverviewAsync.when(
                    data: (overview) {
                      final cardSpendMap = {
                        for (final m in overview.cardMetrics) m.cardId: m.totalSpentPaise
                      };

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
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
