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
import '../../domain/card_enums.dart';
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

  void _showEditCardDialog() {
    final nicknameController = TextEditingController(text: _currentCard.nickname ?? '');
    final bankController = TextEditingController(text: _currentCard.bankName);
    var selectedType = _currentCard.cardType.toUpperCase() == 'CREDIT' ? CardType.credit : CardType.debit;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Card Details', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Card Nickname', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: nicknameController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. Shopping Card, Salary Card',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.surfaceBorder),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Bank Name', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: bankController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. HDFC Bank, SBI Bank, ICICI Bank',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.surfaceBorder),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Card Type', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Debit Card'),
                      selected: selectedType == CardType.debit,
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: selectedType == CardType.debit ? Colors.white : AppColors.textMuted,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) setDialogState(() => selectedType = CardType.debit);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Credit Card'),
                      selected: selectedType == CardType.credit,
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: selectedType == CardType.credit ? Colors.white : AppColors.textMuted,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) setDialogState(() => selectedType = CardType.credit);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final newName = nicknameController.text.trim();
                final newBank = bankController.text.trim().isEmpty ? _currentCard.bankName : bankController.text.trim();
                final repo = ref.read(cardRepositoryProvider);
                await repo.updateCard(
                  id: _currentCard.id,
                  nickname: newName.isEmpty ? newBank : newName,
                  bankName: newBank,
                  cardType: selectedType,
                );
                setState(() {
                  _currentCard = _currentCard.copyWith(
                    nickname: Value(newName.isEmpty ? newBank : newName),
                    bankName: newBank,
                    cardType: selectedType.dbValue,
                  );
                });
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleActiveStatus() async {
    final newStatus = !_currentCard.isActive;
    final repo = ref.read(cardRepositoryProvider);
    await repo.setCardActive(_currentCard.id, newStatus);
    setState(() {
      _currentCard = _currentCard.copyWith(isActive: newStatus);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          content: Text(
            newStatus ? 'Card activated for expense tracking' : 'Card tracking paused',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Card', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to remove ${_currentCard.nickname ?? _currentCard.bankName} (•••• ${_currentCard.lastFour})?\n\nLogged transactions will be preserved as unassigned records.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentError,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final repo = ref.read(cardRepositoryProvider);
              await repo.deleteCard(_currentCard.id);
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (mounted) context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            tooltip: 'Delete Card',
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
                child: Stack(
                  children: [
                    CreditCardWidget(
                      bankName: _currentCard.bankName,
                      cardType: _currentCard.cardType,
                      cardNumber: _currentCard.maskedNumber,
                      network: _currentCard.network,
                      gradientIndex: _currentCard.colorGradientIndex,
                      elevation: 12,
                    ),
                    if (!_currentCard.isActive)
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pause_circle_outline, color: Colors.white70, size: 14),
                              SizedBox(width: 4),
                              Text('PAUSED', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Action Chips (Edit Details, Change Style, Active Toggle)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryLight),
                  label: const Text('Edit Card', style: TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  onPressed: _showEditCardDialog,
                ),
                const SizedBox(width: 10),
                ActionChip(
                  avatar: const Icon(Icons.palette_outlined, size: 16, color: AppColors.primaryLight),
                  label: const Text('Change Style', style: TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  onPressed: _showChangeGradientSheet,
                ),
                const SizedBox(width: 10),
                ActionChip(
                  avatar: Icon(
                    _currentCard.isActive ? Icons.check_circle : Icons.pause_circle_filled,
                    size: 16,
                    color: _currentCard.isActive ? AppColors.success : AppColors.warning,
                  ),
                  label: Text(
                    _currentCard.isActive ? 'Active' : 'Paused',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentCard.isActive ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  onPressed: _toggleActiveStatus,
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 3. Card Metadata Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder, width: 1),
              ),
              child: Column(
                children: [
                  _MetadataRow(label: 'Bank Name', value: _currentCard.bankName),
                  const Divider(color: AppColors.surfaceBorder, height: 18),
                  _MetadataRow(label: 'Classification', value: _currentCard.cardType == 'CREDIT' ? 'Credit Card' : 'Debit Card'),
                  const Divider(color: AppColors.surfaceBorder, height: 18),
                  _MetadataRow(label: 'Network', value: _currentCard.network),
                  const Divider(color: AppColors.surfaceBorder, height: 18),
                  _MetadataRow(label: 'Account Digits', value: '•••• ${_currentCard.lastFour}'),
                  const Divider(color: AppColors.surfaceBorder, height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Auto-Tracking', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Row(
                        children: [
                          Text(
                            _currentCard.isActive ? 'Tracking Active' : 'Tracking Paused',
                            style: TextStyle(
                              color: _currentCard.isActive ? AppColors.success : AppColors.warning,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Switch.adaptive(
                            value: _currentCard.isActive,
                            activeColor: AppColors.primaryAccent,
                            onChanged: (_) => _toggleActiveStatus(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Stats Row (Total Spent, Count, Avg)
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

            // 5. Card Transactions Header
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

            // 6. Isolated Transactions List
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

class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetadataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
