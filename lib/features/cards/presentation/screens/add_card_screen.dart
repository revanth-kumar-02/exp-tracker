import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/card_repository.dart';
import '../../domain/card_enums.dart';
import '../widgets/credit_card_widget.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  final VoidCallback onCardSaved;

  const AddCardScreen({super.key, required this.onCardSaved});

  @override
  ConsumerState<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends ConsumerState<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _bankController = TextEditingController(text: 'HDFC Bank');

  CardType _selectedType = CardType.debit;
  CardNetwork _detectedNetwork = CardNetwork.visa;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_onNumberChanged);
  }

  void _onNumberChanged() {
    final text = _numberController.text.replaceAll(' ', '');
    final network = CardNetwork.fromNumber(text);
    if (network != _detectedNetwork) {
      setState(() => _detectedNetwork = network);
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.removeListener(_onNumberChanged);
    _numberController.dispose();
    _expiryController.dispose();
    _nicknameController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final rawDigits = _numberController.text.replaceAll(' ', '');
      final lastFour = rawDigits.length >= 4
          ? rawDigits.substring(rawDigits.length - 4)
          : rawDigits.padLeft(4, '0');

      final maskedNumber = '•••• •••• •••• $lastFour';
      final bank = _bankController.text.trim().isEmpty ? 'HDFC Bank' : _bankController.text.trim();
      final nickname = _nicknameController.text.trim().isEmpty
          ? '$bank ${_selectedType == CardType.credit ? 'Credit' : 'Debit'}'
          : _nicknameController.text.trim();

      final repo = ref.read(cardRepositoryProvider);
      await repo.addCard(
        id: const Uuid().v4(),
        bankName: bank,
        cardType: _selectedType,
        network: _detectedNetwork,
        maskedNumber: maskedNumber,
        lastFour: lastFour,
        cardholderName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        expiryMonthYear: _expiryController.text.trim().isEmpty ? null : _expiryController.text.trim(),
        nickname: nickname,
        colorGradientIndex: _selectedType == CardType.credit ? 1 : 0,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surface,
            content: Text(
              'Card ending in $lastFour registered successfully',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
        widget.onCardSaved();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Failed to save card: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add New Card', style: AppTypography.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Live Interactive Card Preview
                CreditCardWidget(
                  bankName: _bankController.text.isEmpty ? 'HDFC Bank' : _bankController.text,
                  cardType: _selectedType.displayName,
                  cardNumber: _numberController.text.isEmpty
                      ? '1234 5678 9012 3456'
                      : _numberController.text,
                  cardholderName: _nameController.text.isEmpty ? 'John Doe' : _nameController.text,
                  expiryDate: _expiryController.text.isEmpty ? '12/28' : _expiryController.text,
                  network: _detectedNetwork.displayName,
                  isLivePreview: true,
                  gradientIndex: _selectedType == CardType.credit ? 1 : 0,
                ),

                const SizedBox(height: 28),

                // 2. Form Section Title
                const Text('Card Details', style: AppTypography.headlineMedium),
                const SizedBox(height: 18),

                // 3. Bank Name Selector / Input
                _buildLabel('Bank Name'),
                TextFormField(
                  controller: _bankController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'e.g. HDFC Bank, SBI, ICICI, RBL',
                    prefixIcon: Icon(Icons.account_balance_outlined),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Please enter bank name' : null,
                ),
                const SizedBox(height: 8),
                // Quick Selectable Bank Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildQuickBankChip('HDFC Bank', CardType.debit),
                      _buildQuickBankChip('SBI Bank', CardType.credit),
                      _buildQuickBankChip('ICICI Bank', CardType.credit),
                      _buildQuickBankChip('RBL Bank', CardType.credit),
                      _buildQuickBankChip('Canara Bank', CardType.debit),
                      _buildQuickBankChip('Slice Card', CardType.credit),
                      _buildQuickBankChip('Amazon Pay ICICI', CardType.credit),
                      _buildQuickBankChip('IOB Bank', CardType.debit),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Cardholder Name
                _buildLabel('Cardholder Name'),
                TextFormField(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Enter name on card',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Please enter cardholder name' : null,
                ),
                const SizedBox(height: 16),

                // 5. Card Number (with 4-digit block spacing)
                _buildLabel('Card Number'),
                TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberInputFormatter(),
                  ],
                  decoration: const InputDecoration(
                    hintText: '1234 5678 9012 3456',
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                  validator: (val) {
                    final clean = (val ?? '').replaceAll(' ', '');
                    if (clean.length < 12) return 'Please enter a valid card number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 6. Two-column Row: Expiry Date & Card Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expiry Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Expiry Date'),
                          TextFormField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              _CardExpiryInputFormatter(),
                            ],
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: 'MM / YY',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Card Type Dropdown
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Card Type'),
                          DropdownButtonFormField<CardType>(
                            value: _selectedType,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.layers_outlined),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                            dropdownColor: AppColors.surfaceElevated,
                            items: CardType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.displayName, style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedType = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 7. Card Nickname (Optional)
                _buildLabel('Card Nickname (Optional)'),
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. HDFC Debit',
                    prefixIcon: Icon(Icons.sell_outlined),
                  ),
                ),
                const SizedBox(height: 32),

                // 8. Add Card Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primaryGlow,
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text(
                              'Add Card',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 9. Security Trust Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.security, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Your card information is stored securely on your device.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBankChip(String bank, CardType defaultType) {
    final isSelected = _bankController.text == bank;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(bank),
        backgroundColor: isSelected ? AppColors.primaryGlow : AppColors.surface,
        side: BorderSide(
          color: isSelected ? AppColors.primaryLight : AppColors.surfaceBorder,
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        onPressed: () {
          setState(() {
            _bankController.text = bank;
            _selectedType = defaultType;
            _nicknameController.text = '$bank ${defaultType == CardType.credit ? 'Credit' : 'Debit'}';
          });
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// 4-digit block spacing formatter for card number (e.g. 1234 5678 9012 3456)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// MM / YY formatter for expiry
class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '').replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write(' / ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
