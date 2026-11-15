import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class BatteryOptimizationGuideSheet extends StatelessWidget {
  const BatteryOptimizationGuideSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BatteryOptimizationGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentWarning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.battery_charging_full_rounded,
                  color: AppColors.accentWarning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background Reliability Setup',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Prevent Android OEM battery killers from stopping capture',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Brand accordion/cards
          _buildBrandGuide(
            brand: 'Xiaomi / Redmi / POCO (HyperOS / MIUI)',
            steps: [
              'Go to Settings > Apps > Manage Apps > Expense Tracker',
              'Enable "Autostart"',
              'Set Battery Saver to "No restrictions"',
            ],
            icon: Icons.phone_android_rounded,
          ),
          const SizedBox(height: 10),

          _buildBrandGuide(
            brand: 'Samsung (One UI)',
            steps: [
              'Go to Settings > Apps > Expense Tracker > Battery',
              'Select "Unrestricted"',
              'Add Expense Tracker to "Never sleeping apps"',
            ],
            icon: Icons.shield_outlined,
          ),
          const SizedBox(height: 10),

          _buildBrandGuide(
            brand: 'OnePlus / Realme / OPPO',
            steps: [
              'Go to Settings > Battery > App Battery Management',
              'Select Expense Tracker > Enable "Allow background activity"',
              'Lock the app in the Recent Apps carousel',
            ],
            icon: Icons.electric_bolt_rounded,
          ),
          const SizedBox(height: 10),

          _buildBrandGuide(
            brand: 'Google Pixel & Stock Android',
            steps: [
              'Go to Settings > Apps > Expense Tracker > App battery usage',
              'Change from "Optimized" to "Unrestricted"',
            ],
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(height: 20),

          // Done button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandGuide({
    required String brand,
    required List<String> steps,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  brand,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (int i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
