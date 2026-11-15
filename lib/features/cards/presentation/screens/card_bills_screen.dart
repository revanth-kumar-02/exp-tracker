import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../controllers/card_bills_controller.dart';
import '../../domain/card_bill_model.dart';

class CardBillsScreen extends ConsumerWidget {
  const CardBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(cardBillsProvider);
    final unpaidBills = bills.where((b) => !b.isPaid).toList();
    final totalOutstandingPaise = unpaidBills.fold<int>(
      0,
      (sum, bill) => sum + bill.totalDuePaise,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Credit Card Bills',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_rounded, color: AppColors.primaryLight),
            onPressed: () => context.push('/add-card'),
            tooltip: 'Add Card',
          ),
        ],
      ),
      body: bills.isEmpty
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Total Outstanding Summary Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E1B4E), Color(0xFF1E1735)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL OUTSTANDING',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: unpaidBills.isEmpty
                                    ? AppColors.accentSuccess.withOpacity(0.2)
                                    : AppColors.accentWarning.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                unpaidBills.isEmpty
                                    ? 'All Paid 🎉'
                                    : '${unpaidBills.length} Due',
                                style: TextStyle(
                                  color: unpaidBills.isEmpty
                                      ? AppColors.accentSuccess
                                      : AppColors.accentWarning,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          CurrencyFormatter.formatPaise(totalOutstandingPaise),
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Estimated cycle balance across ${bills.length} credit card${bills.length > 1 ? 's' : ''}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Section Title
                  Text(
                    'Card Payment Due Dates',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Card Bills List
                  for (final bill in bills) ...[
                    _CardBillTile(bill: bill),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.credit_card_off_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Credit Cards Added',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your credit cards to automatically calculate billing cycles and track payment deadlines.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Credit Card'),
              onPressed: () => context.push('/add-card'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBillTile extends ConsumerWidget {
  final CardBill bill;

  const _CardBillTile({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd MMM yyyy');

    Color statusColor;
    String statusText;

    if (bill.isPaid) {
      statusColor = AppColors.accentSuccess;
      statusText = 'Paid';
    } else if (bill.isOverdue) {
      statusColor = AppColors.accentError;
      statusText = 'Overdue by ${bill.daysRemaining.abs()}d';
    } else if (bill.daysRemaining == 0) {
      statusColor = AppColors.accentWarning;
      statusText = 'Due Today';
    } else if (bill.daysRemaining <= 3) {
      statusColor = AppColors.accentWarning;
      statusText = 'Due in ${bill.daysRemaining} days';
    } else {
      statusColor = AppColors.primaryLight;
      statusText = 'Due in ${bill.daysRemaining} days';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: bill.isPaid
              ? AppColors.surfaceBorder
              : (bill.isOverdue
                  ? AppColors.accentError.withOpacity(0.5)
                  : AppColors.surfaceBorder),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Card bank + last 4 + Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.credit_card, size: 18, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.card.nickname ?? bill.card.bankName,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '•••• ${bill.card.lastFour} • ${bill.card.network}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Middle Row: Amount & Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill Amount',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.formatPaise(bill.totalDuePaise),
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: bill.isPaid ? AppColors.textMuted : Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Due Date',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateFormat.format(bill.dueDate),
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AppColors.surfaceBorder, height: 1),
          const SizedBox(height: 12),

          // Bottom Action: Mark Paid toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statement generated: ${dateFormat.format(bill.statementDate)}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: bill.isPaid ? AppColors.textMuted : AppColors.accentSuccess,
                  side: BorderSide(
                    color: bill.isPaid ? AppColors.surfaceBorder : AppColors.accentSuccess,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  bill.isPaid ? Icons.check_circle : Icons.check_circle_outline,
                  size: 14,
                ),
                label: Text(
                  bill.isPaid ? 'Mark Unpaid' : 'Mark Paid',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  ref.read(paidBillsProvider.notifier).togglePaid(bill.card.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.surface,
                      content: Text(
                        bill.isPaid
                            ? 'Marked ${bill.card.nickname ?? bill.card.bankName} bill as Unpaid'
                            : 'Marked ${bill.card.nickname ?? bill.card.bankName} bill as Paid! 🎉',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
