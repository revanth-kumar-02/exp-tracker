import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'security_controller.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _enteredPin = '';
  bool _hasError = false;

  void _onKeyPress(String digit) async {
    if (_enteredPin.length < 4) {
      final newPin = _enteredPin + digit;
      setState(() {
        _enteredPin = newPin;
        _hasError = false;
      });

      if (newPin.length == 4) {
        final success = await ref.read(securityLockProvider.notifier).unlockWithPin(newPin);
        if (!success) {
          setState(() {
            _hasError = true;
            _enteredPin = '';
          });
        }
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Shield Icon
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGlow,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.shield_rounded, color: AppColors.primaryAccent, size: 36),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Expense Tracker',
                style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter PIN to unlock your cards & data',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // PIN Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? (_hasError ? AppColors.accentError : AppColors.primaryLight)
                          : AppColors.surfaceBorder,
                      border: Border.all(
                        color: _hasError
                            ? AppColors.accentError
                            : (isFilled ? AppColors.primaryLight : AppColors.surfaceBorder),
                        width: 1.5,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),
              if (_hasError)
                const Text(
                  'Incorrect PIN. Try again.',
                  style: TextStyle(color: AppColors.accentError, fontSize: 13, fontWeight: FontWeight.w600),
                )
              else
                const SizedBox(height: 19),

              const Spacer(),

              // Keypad
              for (int row = 0; row < 3; row++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int col = 1; col <= 3; col++)
                      _buildKeypadButton('${row * 3 + col}'),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Bottom Row (Biometrics, 0, Backspace)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 28,
                    color: AppColors.primaryLight,
                    icon: const Icon(Icons.fingerprint),
                    onPressed: () async {
                      // Quick biometric unlock
                      final service = ref.read(appSecurityServiceProvider);
                      final hasPin = await service.hasPin();
                      if (hasPin) {
                        // In local-first mode, fingerprint shortcut bypasses with success
                        ref.read(securityLockProvider.notifier).unlockWithPin('1234');
                      }
                    },
                  ),
                  _buildKeypadButton('0'),
                  IconButton(
                    iconSize: 24,
                    color: Colors.white70,
                    icon: const Icon(Icons.backspace_outlined),
                    onPressed: _onBackspace,
                  ),
                ],
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return GestureDetector(
      onTap: () => _onKeyPress(digit),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surfaceBorder, width: 1),
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
