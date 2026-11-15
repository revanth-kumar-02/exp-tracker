import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/security/app_lock_screen.dart';
import '../core/security/security_controller.dart';
import '../core/theme/app_colors.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTabSelected;

  const ShellScreen({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityState = ref.watch(securityLockProvider);

    if (securityState.isLockEnabled && !securityState.isAppUnlocked) {
      return const AppLockScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.surfaceBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabSelected,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              activeIcon: Icon(Icons.swap_horiz),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined),
              activeIcon: Icon(Icons.credit_card),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              activeIcon: Icon(Icons.track_changes),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Insights',
            ),
          ],
        ),
      ),
    );
  }
}
