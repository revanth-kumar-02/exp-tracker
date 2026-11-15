import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'core/theme/app_theme.dart';
import 'features/cards/data/card_repository.dart';
import 'features/cards/domain/card_enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ProviderContainer to seed demo cards if database is empty
  final container = ProviderContainer();
  final cardRepo = container.read(cardRepositoryProvider);
  final existingCards = await cardRepo.getActiveCards();

  if (existingCards.isEmpty) {
    // Seed initial cards matching the reference UI
    await cardRepo.addCard(
      id: 'demo_card_hdfc',
      bankName: 'HDFC Bank',
      cardType: CardType.debit,
      network: CardNetwork.visa,
      maskedNumber: '•••• •••• •••• 4821',
      lastFour: '4821',
      cardholderName: 'John Doe',
      expiryMonthYear: '12/28',
      nickname: 'HDFC Debit',
      colorGradientIndex: 0,
    );

    await cardRepo.addCard(
      id: 'demo_card_sbi',
      bankName: 'SBI Bank',
      cardType: CardType.credit,
      network: CardNetwork.visa,
      maskedNumber: '•••• •••• •••• 7290',
      lastFour: '7290',
      cardholderName: 'John Doe',
      expiryMonthYear: '08/29',
      nickname: 'SBI Credit',
      colorGradientIndex: 1,
    );

    await cardRepo.addCard(
      id: 'demo_card_icici',
      bankName: 'ICICI Bank',
      cardType: CardType.credit,
      network: CardNetwork.visa,
      maskedNumber: '•••• •••• •••• 1934',
      lastFour: '1934',
      cardholderName: 'John Doe',
      expiryMonthYear: '04/27',
      nickname: 'ICICI Credit',
      colorGradientIndex: 2,
    );
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
