import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'security_controller.dart';

class SecuritySettingsDialog extends ConsumerStatefulWidget {
  const SecuritySettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const SecuritySettingsDialog(),
    );
  }

  @override
  ConsumerState<SecuritySettingsDialog> createState() => _SecuritySettingsDialogState();
}

class _SecuritySettingsDialogState extends ConsumerState<SecuritySettingsDialog> {
  final _pinController = TextEditingController();
  bool _isSettingNewPin = false;

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(securityLockProvider);

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGlow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shield_outlined, color: AppColors.primaryLight, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Security & App Lock',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Protect your financial cards and transaction logs with a private 4-digit PIN on this device.',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Status & Switch Tile
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      securityState.isLockEnabled ? Icons.lock : Icons.lock_open_rounded,
                      color: securityState.isLockEnabled ? AppColors.accentSuccess : AppColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      securityState.isLockEnabled ? 'Lock is Active' : 'Lock Disabled',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
                Switch(
                  value: securityState.isLockEnabled,
                  activeColor: AppColors.primaryLight,
                  onChanged: (enabled) {
                    if (enabled) {
                      setState(() {
                        _isSettingNewPin = true;
                      });
                    } else {
                      ref.read(securityLockProvider.notifier).disableLock();
                    }
                  },
                ),
              ],
            ),
          ),

          if (_isSettingNewPin) ...[
            const SizedBox(height: 16),
            const Text(
              'Enter New 4-Digit PIN:',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              style: const TextStyle(color: Colors.white, letterSpacing: 8, fontSize: 18),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••',
                hintStyle: const TextStyle(color: AppColors.textMuted, letterSpacing: 8),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.surfaceBorder),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  final pin = _pinController.text.trim();
                  if (pin.length == 4) {
                    ref.read(securityLockProvider.notifier).enableLockWithPin(pin);
                    setState(() {
                      _isSettingNewPin = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App Lock enabled successfully!')),
                    );
                  }
                },
                child: const Text('Save PIN', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],

          if (securityState.isLockEnabled && !_isSettingNewPin) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
                side: const BorderSide(color: AppColors.surfaceBorder),
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.lock_clock, size: 16),
              label: const Text('Lock App Now', style: TextStyle(fontSize: 12)),
              onPressed: () {
                ref.read(securityLockProvider.notifier).lockAppNow();
                Navigator.pop(context);
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
