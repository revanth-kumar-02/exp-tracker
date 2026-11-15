import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../budgets/presentation/controllers/budget_controller.dart';
import '../../data/card_repository.dart';
import '../widgets/credit_card_widget.dart';

class CardDetailsScreen extends ConsumerStatefulWidget {
  final PaymentCardData card;

  const CardDetailsScreen({super.key, required this.card});

  @override
  ConsumerState<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends ConsumerState<CardDetailsScreen> {
  late PaymentCardData _currentCard;

  @override
  void initState() {
    super.initState();
    _currentCard = widget.card;
  }

  void _showEditNicknameDialog() {
    final controller = TextEditingController(text: _currentCard.nickname ?? '');
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Edit Card Nickname', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Shopping Card, Travel Card',
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.surfaceBorder),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              final newName = controller.text.trim();
              final repo = ref.read(cardRepositoryProvider);
              await repo.updateCard(
                id: _currentCard.id,
                nickname: newName.isEmpty ? _currentCard.bankName : newName,
              );
              setState(() {
                _currentCard = _currentCard.copyWith(
                  nickname: Value(newName.isEmpty ? _currentCard.bankName : newName),
                );
              });
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangeGradientSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Card Style',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(6, (idx) {
                  final isSelected = _currentCard.colorGradientIndex == idx;
                  return GestureDetector(
                    onTap: () async {
                      final repo = ref.read(cardRepositoryProvider);
                      await repo.updateCard(id: _currentCard.id, colorGradientIndex: idx);
                      setState(() {
                        _currentCard = _currentCard.copyWith(colorGradientIndex: idx);
                      });
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradients[idx],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteCard() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Remove Card', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove ${_currentCard.nickname ?? _currentCard.bankName} (•••• ${_currentCard.lastFour})? Logged transactions will remain saved.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentError),
            onPressed: () async {
              final repo = ref.read(cardRepositoryProvider);
              await repo.deleteCard(_currentCard.id);
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (mounted) context.pop();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTxsAsync = ref.watch(allTransactionsStreamProvider);
    final txs = (allTxsAsync.asData?.value ?? <TransactionData>[])
        .where((t) => t.paymentCardId == _currentCard.id)
        .toList();

    int totalSpentPaise = 0;
    for (final t in txs) {
      if (t.transactionType.toUpperCase() == 'DEBIT') {
        totalSpentPaise += t.amountPaise;
      }
    }

    final avgSpendPaise = txs.isNotEmpty ? (totalSpentPaise ~/ txs.length) : 0;
    final dateFormat = DateFormat('dd MMM, hh:mm a');

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
          _currentCard.nickname ?? _currentCard.bankName,
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.accentError),
            onPressed: _confirmDeleteCard,
            tooltip: 'Remove Card',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Large Visual Card Display
            Center(
              child: SizedBox(
                width: 320,
                height: 195,
                child: CreditCardWidget(
                  bankName: _currentCard.bankName,
                  cardType: _currentCard.cardType,
                  cardNumber: _currentCard.maskedNumber,
                  network: _currentCard.network,
                  gradientIndex: _currentCard.colorGradientIndex,
                  elevation: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Action Chips (Edit Nickname, Change Color)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryLight),
                  label: const Text('Edit Name', style: TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  onPressed: _showEditNicknameDialog,
                ),
                const SizedBox(width: 12),
                ActionChip(
                  avatar: const Icon(Icons.palette_outlined, size: 16, color: AppColors.primaryLight),
                  label: const Text('Change Style', style: TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  onPressed: _showChangeGradientSheet,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Stats Row (Total Spent, Count, Avg)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Spent', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatPaise(totalSpentPaise),
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 36, color: AppColors.surfaceBorder),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transactions', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                            '${txs.length}',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 36, color: AppColors.surfaceBorder),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Avg. Spend', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.formatPaise(avgSpendPaise),
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Card Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card Transactions',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${txs.length} recorded',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 5. Isolated Transactions List
            if (txs.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder, width: 1),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long_outlined, size: 36, color: AppColors.textMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No Transactions Yet',
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Incoming bank notifications for card •••• ${_currentCard.lastFour} will appear here.',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              for (final tx in txs)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
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
                            child: const Icon(Icons.storefront_outlined, size: 18, color: Colors.white70),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.merchant,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dateFormat.format(tx.occurredAt),
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
                        '-${CurrencyFormatter.formatPaise(tx.amountPaise)}',
                        style: const TextStyle(
                          color: AppColors.accentExpense,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
