import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../cards/presentation/controllers/card_controller.dart';
import '../../../budgets/presentation/controllers/budget_controller.dart';
import '../../data/transaction_repository.dart';
import '../controllers/transaction_controller.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListStreamProvider);
    final unassignedCountAsync = ref.watch(unassignedTransactionsCountProvider);
    final activeTab = ref.watch(transactionTabFilterProvider);
    final selectedCardId = ref.watch(selectedCardFilterProvider);
    final activeDateRange = ref.watch(dateRangeFilterProvider);
    final searchQuery = ref.watch(transactionSearchQueryProvider);
    final cardsAsync = ref.watch(cardsStreamProvider);

    final unassignedCount = unassignedCountAsync.asData?.value ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryAccent),
            tooltip: 'Add Manual Expense',
            onPressed: () => _showManualExpenseSheet(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // 1. "Needs Review" Banner if unassigned transactions exist
            if (unassignedCount > 0 && activeTab != TransactionTabFilter.needsReview)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: GestureDetector(
                  onTap: () {
                    ref.read(transactionTabFilterProvider.notifier).setFilter(TransactionTabFilter.needsReview);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$unassignedCount transaction${unassignedCount > 1 ? 's' : ''} need card review',
                            style: const TextStyle(
                              color: AppColors.warning,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          'Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search merchant, store or description...',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 16),
                            onPressed: () {
                              ref.read(transactionSearchQueryProvider.notifier).setQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (val) {
                    ref.read(transactionSearchQueryProvider.notifier).setQuery(val);
                  },
                ),
              ),
            ),

            // 2. Status Filter Tabs (All, Needs Review, Confirmed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    _TabPill(
                      label: 'All',
                      isSelected: activeTab == TransactionTabFilter.all,
                      onTap: () => ref.read(transactionTabFilterProvider.notifier).setFilter(TransactionTabFilter.all),
                    ),
                    _TabPill(
                      label: unassignedCount > 0 ? 'Review ($unassignedCount)' : 'Needs Review',
                      isSelected: activeTab == TransactionTabFilter.needsReview,
                      isHighlighted: unassignedCount > 0,
                      onTap: () => ref.read(transactionTabFilterProvider.notifier).setFilter(TransactionTabFilter.needsReview),
                    ),
                    _TabPill(
                      label: 'Confirmed',
                      isSelected: activeTab == TransactionTabFilter.confirmed,
                      onTap: () => ref.read(transactionTabFilterProvider.notifier).setFilter(TransactionTabFilter.confirmed),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Horizontal Card Filter Chips
            cardsAsync.when(
              data: (cards) {
                if (cards.isEmpty) return const SizedBox.shrink();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      FilterChip(
                        selected: selectedCardId == null,
                        label: const Text('All Cards'),
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primaryGlow,
                        side: BorderSide(
                          color: selectedCardId == null ? AppColors.primaryLight : AppColors.surfaceBorder,
                        ),
                        labelStyle: TextStyle(
                          color: selectedCardId == null ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => ref.read(selectedCardFilterProvider.notifier).setCardId(null),
                      ),
                      const SizedBox(width: 8),
                      ...cards.map((c) {
                        final isSel = selectedCardId == c.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSel,
                            label: Text('${c.bankName} ••${c.lastFour}'),
                            backgroundColor: AppColors.surface,
                            selectedColor: AppColors.primaryGlow,
                            side: BorderSide(
                              color: isSel ? AppColors.primaryLight : AppColors.surfaceBorder,
                            ),
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (_) {
                              ref.read(selectedCardFilterProvider.notifier).setCardId(isSel ? null : c.id);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Date Range Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _DateFilterChip(
                    label: 'All Time',
                    isSelected: activeDateRange == DateRangeFilter.all,
                    onTap: () => ref.read(dateRangeFilterProvider.notifier).setRange(DateRangeFilter.all),
                  ),
                  const SizedBox(width: 6),
                  _DateFilterChip(
                    label: 'This Week',
                    isSelected: activeDateRange == DateRangeFilter.thisWeek,
                    onTap: () => ref.read(dateRangeFilterProvider.notifier).setRange(DateRangeFilter.thisWeek),
                  ),
                  const SizedBox(width: 6),
                  _DateFilterChip(
                    label: 'This Month',
                    isSelected: activeDateRange == DateRangeFilter.thisMonth,
                    onTap: () => ref.read(dateRangeFilterProvider.notifier).setRange(DateRangeFilter.thisMonth),
                  ),
                  const SizedBox(width: 6),
                  _DateFilterChip(
                    label: 'Last Month',
                    isSelected: activeDateRange == DateRangeFilter.lastMonth,
                    onTap: () => ref.read(dateRangeFilterProvider.notifier).setRange(DateRangeFilter.lastMonth),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 4. Transactions List
            Expanded(
              child: transactionsAsync.when(
                data: (txs) {
                  if (txs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                            ),
                            child: const Icon(Icons.receipt_long_outlined, color: AppColors.textMuted, size: 28),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            activeTab == TransactionTabFilter.needsReview
                                ? 'No Transactions Need Review'
                                : 'No Transactions Found',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            activeTab == TransactionTabFilter.needsReview
                                ? 'All captured notifications have been assigned to registered cards.'
                                : 'Incoming financial notifications will automatically appear here.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: txs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tx = txs[index];
                      return _TransactionListItem(
                        transaction: tx,
                        onTap: () => _showTransactionDetailsSheet(context, ref, tx),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetailsSheet(BuildContext context, WidgetRef ref, TransactionData tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TransactionDetailsSheet(transaction: tx),
    );
  }

  void _showManualExpenseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _ManualExpenseSheet(),
    );
  }
}

// Transaction List Tile
class _TransactionListItem extends StatelessWidget {
  final TransactionData transaction;
  final VoidCallback onTap;

  const _TransactionListItem({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnassigned = transaction.matchStatus == 'UNASSIGNED';
    final isCredit = transaction.transactionType.toUpperCase() == 'CREDIT';
    final isRefund = transaction.transactionType.toUpperCase() == 'REFUND';

    final dateStr = DateFormat('dd MMM, hh:mm a').format(transaction.occurredAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnassigned
                ? AppColors.warning.withOpacity(0.5)
                : AppColors.surfaceBorder,
            width: isUnassigned ? 1.2 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isUnassigned
                    ? AppColors.warning.withOpacity(0.15)
                    : (isCredit || isRefund)
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.primaryLight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUnassigned
                    ? Icons.help_outline
                    : isCredit
                        ? Icons.arrow_downward
                        : isRefund
                            ? Icons.replay
                            : Icons.shopping_bag_outlined,
                color: isUnassigned
                    ? AppColors.warning
                    : (isCredit || isRefund)
                        ? AppColors.success
                        : AppColors.primaryAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Merchant & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchant,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isUnassigned) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Needs Review',
                            style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        dateStr,
                        style: AppTypography.bodySmall.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(isCredit || isRefund) ? '+' : '-'}${CurrencyFormatter.formatPaise(transaction.amountPaise)}',
                  style: AppTypography.titleMedium.copyWith(
                    color: (isCredit || isRefund) ? AppColors.success : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.transactionType,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.isSelected,
    this.isHighlighted = false,
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
            borderRadius: BorderRadius.circular(18),
            gradient: isSelected ? AppColors.activePillGradient : null,
            border: isSelected
                ? Border.all(color: AppColors.primaryLight.withOpacity(0.5))
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isHighlighted
                        ? AppColors.warning
                        : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Transaction Details / Card Assignment Sheet
class _TransactionDetailsSheet extends ConsumerStatefulWidget {
  final TransactionData transaction;

  const _TransactionDetailsSheet({required this.transaction});

  @override
  ConsumerState<_TransactionDetailsSheet> createState() => _TransactionDetailsSheetState();
}

class _TransactionDetailsSheetState extends ConsumerState<_TransactionDetailsSheet> {
  late final TextEditingController _merchantController;
  String? _selectedCardId;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController(text: widget.transaction.merchant);
    _selectedCardId = widget.transaction.paymentCardId;
    _selectedCategoryId = widget.transaction.categoryId;
  }

  @override
  void dispose() {
    _merchantController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final repo = ref.read(transactionRepositoryProvider);

    await repo.updateTransactionDetails(
      transactionId: widget.transaction.id,
      merchant: _merchantController.text.trim(),
      categoryId: _selectedCategoryId,
      paymentCardId: _selectedCardId,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction updated successfully')),
      );
    }
  }

  Future<void> _handleDelete() async {
    final repo = ref.read(transactionRepositoryProvider);
    await repo.deleteTransaction(widget.transaction.id);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsStreamProvider);
    final categoriesAsync = ref.watch(allCategoriesStreamProvider);
    final isUnassigned = widget.transaction.matchStatus == 'UNASSIGNED';

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isUnassigned ? 'Review Transaction' : 'Transaction Details',
                  style: AppTypography.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: _handleDelete,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Amount Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    CurrencyFormatter.formatPaise(widget.transaction.amountPaise),
                    style: AppTypography.displayLarge.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.transaction.transactionType} • ${DateFormat('dd MMMM yyyy, hh:mm a').format(widget.transaction.occurredAt)}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Merchant Name
            const Text('Merchant / Payee', style: AppTypography.bodySmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _merchantController,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.storefront_outlined)),
            ),
            const SizedBox(height: 16),

            // Assigned Card
            const Text('Assigned Card', style: AppTypography.bodySmall),
            const SizedBox(height: 6),
            cardsAsync.when(
              data: (cards) => DropdownButtonFormField<String>(
                value: _selectedCardId,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.credit_card)),
                dropdownColor: AppColors.surface,
                hint: const Text('Unassigned (Select a card)'),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Unassigned', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  ...cards.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.bankName} ••${c.lastFour} (${c.cardType})', style: const TextStyle(color: Colors.white)),
                  )),
                ],
                onChanged: (val) => setState(() => _selectedCardId = val),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Category Picker
            const Text('Category', style: AppTypography.bodySmall),
            const SizedBox(height: 6),
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
                dropdownColor: AppColors.surface,
                hint: const Text('Select category'),
                items: categories.map((cat) => DropdownMenuItem(
                  value: cat.id,
                  child: Text(cat.name, style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            if (widget.transaction.rawNotificationText != null) ...[
              const SizedBox(height: 16),
              const Text('Captured Notification Snippet', style: AppTypography.bodySmall),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  widget.transaction.rawNotificationText!,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Save / Confirm Button
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
                  child: Text(
                    isUnassigned ? 'Confirm Card Assignment' : 'Save Changes',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Manual Expense Sheet Modal
class _ManualExpenseSheet extends ConsumerStatefulWidget {
  const _ManualExpenseSheet();

  @override
  ConsumerState<_ManualExpenseSheet> createState() => _ManualExpenseSheetState();
}

class _ManualExpenseSheetState extends ConsumerState<_ManualExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  String? _cardId;
  String? _categoryId;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final paise = CurrencyFormatter.parseToPaise(_amountController.text.trim());
    final repo = ref.read(transactionRepositoryProvider);

    await repo.addManualTransaction(
      id: const Uuid().v4(),
      amountPaise: paise,
      merchant: _merchantController.text.trim(),
      paymentCardId: _cardId,
      categoryId: _categoryId,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
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
                  const Text('Add Manual Expense', style: AppTypography.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Amount
              const Text('Amount (₹)', style: AppTypography.bodySmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'e.g. 500',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter an amount';
                  final num = int.tryParse(val.trim());
                  if (num == null || num <= 0) return 'Please enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Merchant
              const Text('Merchant / Payee', style: AppTypography.bodySmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Grocery Store, Coffee Shop',
                  prefixIcon: Icon(Icons.storefront_outlined),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter merchant' : null,
              ),
              const SizedBox(height: 16),

              // Card Picker
              const Text('Paid With (Card)', style: AppTypography.bodySmall),
              const SizedBox(height: 6),
              cardsAsync.when(
                data: (cards) => DropdownButtonFormField<String>(
                  value: _cardId,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.credit_card)),
                  dropdownColor: AppColors.surface,
                  hint: const Text('Select payment card (optional)'),
                  items: [
                    const DropdownMenuItem<String>(value: null, child: Text('No Card / Cash', style: TextStyle(color: AppColors.textMuted))),
                    ...cards.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.bankName} ••${c.lastFour}', style: const TextStyle(color: Colors.white)),
                    )),
                  ],
                  onChanged: (val) => setState(() => _cardId = val),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Category Picker
              const Text('Category', style: AppTypography.bodySmall),
              const SizedBox(height: 6),
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  value: _categoryId,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
                  dropdownColor: AppColors.surface,
                  hint: const Text('Select category (optional)'),
                  items: categories.map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.name, style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: (val) => setState(() => _categoryId = val),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
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
                    child: const Text('Add Transaction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
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

class _DateFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGlow : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
