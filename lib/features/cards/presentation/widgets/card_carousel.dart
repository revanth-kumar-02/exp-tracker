import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import 'credit_card_widget.dart';

class CardCarousel extends StatefulWidget {
  final List<PaymentCardData> cards;
  final Function(int) onCardChanged;
  final VoidCallback onAddCard;
  final Function(PaymentCardData)? onCardTap;

  const CardCarousel({
    super.key,
    required this.cards,
    required this.onCardChanged,
    required this.onAddCard,
    this.onCardTap,
  });

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return GestureDetector(
        onTap: widget.onAddCard,
        child: Container(
          height: 190,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surface,
            border: Border.all(
              color: AppColors.primaryLight.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGlow,
                ),
                child: const Icon(Icons.add, color: AppColors.primaryAccent, size: 28),
              ),
              const SizedBox(height: 12),
              const Text(
                'Add Your First Card',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Debit or Credit for automatic tracking',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.cards.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onCardChanged(index);
            },
            itemBuilder: (context, index) {
              final card = widget.cards[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.12)).clamp(0.88, 1.0);
                  } else {
                    value = index == _currentIndex ? 1.0 : 0.9;
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 195,
                      width: Curves.easeOut.transform(value) * 320,
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () => widget.onCardTap?.call(card),
                  child: CreditCardWidget(
                    bankName: card.bankName,
                    cardType: card.cardType,
                    cardNumber: card.maskedNumber,
                    network: card.network,
                    gradientIndex: card.colorGradientIndex,
                    elevation: index == _currentIndex ? 12 : 4,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        // Page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.cards.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 8 : 6,
              height: _currentIndex == index ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.white
                    : const Color(0xFF4A4A60),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
