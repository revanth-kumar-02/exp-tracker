import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/native_bridge.dart';
import 'battery_optimization_guide_sheet.dart';

class NotificationPermissionBanner extends ConsumerWidget {
  const NotificationPermissionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGranted = ref.watch(notificationPermissionProvider);

    if (isGranted) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1728),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accentWarning.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accentWarning.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: AppColors.accentWarning,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Access Required',
                      style: AppTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Grant notification access so the app can detect bank alerts and log your expenses automatically.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.settings, size: 14),
                  label: const Text(
                    'Enable Access',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    final bridge = ref.read(nativeBridgeProvider);
                    await bridge.openNotificationSettings();
                    // Re-check permission after user returns
                    await Future.delayed(const Duration(milliseconds: 1000));
                    ref.read(notificationPermissionProvider.notifier).refreshPermission();
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  BatteryOptimizationGuideSheet.show(context);
                },
                child: const Text(
                  'Battery Tips',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
