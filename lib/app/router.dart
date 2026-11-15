import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/database/app_database.dart';
import '../features/cards/presentation/screens/add_card_screen.dart';
import '../features/cards/presentation/screens/card_bills_screen.dart';
import '../features/cards/presentation/screens/card_details_screen.dart';
import '../features/cards/presentation/screens/dashboard_screen.dart';
import '../features/transactions/presentation/screens/transactions_screen.dart';
import '../features/budgets/presentation/screens/budgets_screen.dart';
import '../features/insights/presentation/screens/insights_screen.dart';
import 'shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScreen(
          currentIndex: navigationShell.currentIndex,
          onTabSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          child: navigationShell,
        );
      },
      branches: [
        // 0: Home / Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => DashboardScreen(
                onAddCard: () => context.push('/add-card'),
                onBudgets: () => context.go('/budgets'),
                onAnalytics: () => context.go('/insights'),
                onCardBills: () => context.push('/card-bills'),
              ),
            ),
          ],
        ),

        // 1: Transactions
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsScreen(),
            ),
          ],
        ),

        // 2: Cards
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cards',
              builder: (context, state) => DashboardScreen(
                onAddCard: () => context.push('/add-card'),
                onBudgets: () => context.go('/budgets'),
                onAnalytics: () => context.go('/insights'),
                onCardBills: () => context.push('/card-bills'),
              ),
            ),
          ],
        ),

        // 3: Budgets
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/budgets',
              builder: (context, state) => const BudgetsScreen(),
            ),
          ],
        ),

        // 4: Insights
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/insights',
              builder: (context, state) => const InsightsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Add Card Modal Route
    GoRoute(
      path: '/add-card',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => AddCardScreen(
        onCardSaved: () => context.pop(),
      ),
    ),

    // Card Bills Route
    GoRoute(
      path: '/card-bills',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CardBillsScreen(),
    ),

    // Card Details Route
    GoRoute(
      path: '/card-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final card = state.extra as PaymentCardData;
        return CardDetailsScreen(card: card);
      },
    ),
  ],
);
