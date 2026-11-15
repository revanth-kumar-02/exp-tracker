import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class QuickActionsGrid extends StatelessWidget {
  final VoidCallback onAddCard;
  final VoidCallback onBudgets;
  final VoidCallback onAnalytics;
  final VoidCallback onCardBills;

  const QuickActionsGrid({
    super.key,
    required this.onAddCard,
    required this.onBudgets,
    required this.onAnalytics,
    required this.onCardBills,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionTile(
            icon: Icons.add,
            label: 'Add Card',
            onTap: onAddCard,
          ),
          _ActionTile(
            icon: Icons.track_changes, // target / bullseye for budgets
            label: 'Budgets',
            onTap: onBudgets,
          ),
          _ActionTile(
            icon: Icons.bar_chart_rounded,
            label: 'Analytics',
            onTap: onAnalytics,
          ),
          _ActionTile(
            icon: Icons.calendar_month_outlined,
            label: 'Card Bills',
            onTap: onCardBills,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder, width: 1),
            ),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryAccent, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
