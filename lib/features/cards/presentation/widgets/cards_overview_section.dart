import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'card_decorations.dart';

class CardsOverviewSection extends StatelessWidget {
  final int totalSpentPaise;
  final double deltaPercent;
  final List<PaymentCardData> cards;
  final Map<String, int> cardSpendMap;

  const CardsOverviewSection({
    super.key,
    required this.totalSpentPaise,
    this.deltaPercent = -12.0,
    required this.cards,
    required this.cardSpendMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cards Overview', style: AppTypography.titleLarge),
              Text(
                'This month',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Overview Container
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Total Spent & Delta Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Spent',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatPaise(totalSpentPaise),
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    // Delta Badge (e.g. ↓ 12% vs last month)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_downward, color: AppColors.success, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${deltaPercent.abs().toInt()}% vs last month',
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Card-wise Progress List
                if (cards.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'No card transactions yet this month',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  ...cards.map((card) {
                    final spend = cardSpendMap[card.id] ?? 0;
                    final double percent = totalSpentPaise > 0
                        ? (spend / totalSpentPaise).clamp(0.0, 1.0)
                        : 0.0;

                    return _CardProgressRow(
                      card: card,
                      spentPaise: spend,
                      percentage: percent,
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardProgressRow extends StatelessWidget {
  final PaymentCardData card;
  final int spentPaise;
  final double percentage;

  const _CardProgressRow({
    required this.card,
    required this.spentPaise,
    required this.percentage,
  });

  Color get _barColor {
    switch (card.colorGradientIndex % 3) {
      case 0:
        return const Color(0xFF8B5CF6); // Purple
      case 1:
        return const Color(0xFF3B82F6); // Blue
      case 2:
        return const Color(0xFFF97316); // Orange
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int percentInt = (percentage * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Bank Logo
          BankLogoWidget(bankName: card.bankName, size: 28),
          const SizedBox(width: 12),

          // Name and Progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.bankName} ${card.cardType == 'CREDIT' ? 'Credit' : 'Debit'} ••${card.lastFour}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage == 0 ? 0.05 : percentage,
                    minHeight: 5,
                    backgroundColor: AppColors.progressTrack,
                    valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Amount and percentage on right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatPaise(spentPaise),
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$percentInt%',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
