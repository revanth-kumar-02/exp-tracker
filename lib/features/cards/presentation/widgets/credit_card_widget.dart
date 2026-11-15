import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'card_decorations.dart';

class CreditCardWidget extends StatelessWidget {
  final String bankName;
  final String cardType;
  final String cardNumber; // Full or Masked
  final String? cardholderName;
  final String? expiryDate;
  final String network;
  final int gradientIndex;
  final bool isLivePreview;
  final double elevation;

  const CreditCardWidget({
    super.key,
    required this.bankName,
    required this.cardType,
    required this.cardNumber,
    this.cardholderName,
    this.expiryDate,
    required this.network,
    this.gradientIndex = 0,
    this.isLivePreview = false,
    this.elevation = 8,
  });

  LinearGradient get _gradient {
    final upper = bankName.toUpperCase();
    if (upper.contains('AMAZON')) return AppColors.amazonPayCardGradient;
    if (upper.contains('SLICE')) return AppColors.sliceCardGradient;
    if (upper.contains('CANARA')) return AppColors.canaraCardGradient;
    if (upper.contains('RBL')) return AppColors.rblCardGradient;
    if (upper.contains('IOB') || upper.contains('OVERSEAS')) return AppColors.iobCardGradient;

    switch (gradientIndex % 8) {
      case 0:
        return AppColors.hdfcCardGradient;
      case 1:
        return AppColors.sbiCardGradient;
      case 2:
        return AppColors.iciciCardGradient;
      case 3:
        return AppColors.rblCardGradient;
      case 4:
        return AppColors.canaraCardGradient;
      case 5:
        return AppColors.sliceCardGradient;
      case 6:
        return AppColors.amazonPayCardGradient;
      case 7:
        return AppColors.iobCardGradient;
      default:
        return AppColors.hdfcCardGradient;
    }
  }

  Color get _glowColor {
    final upper = bankName.toUpperCase();
    if (upper.contains('AMAZON')) return const Color(0x66FF9900); // Amber glow
    if (upper.contains('SLICE')) return const Color(0x668B5CF6); // Neon Purple glow
    if (upper.contains('CANARA')) return const Color(0x66FFCC00); // Gold glow
    if (upper.contains('RBL')) return const Color(0x55005697); // Blue glow
    if (upper.contains('IOB') || upper.contains('OVERSEAS')) return const Color(0x66FFD700); // Imperial Gold glow

    switch (gradientIndex % 8) {
      case 0:
        return const Color(0x668B5CF6); // Violet glow
      case 1:
        return const Color(0x5500A3E0); // Cyan glow
      case 2:
        return const Color(0x55F37021); // Amber glow
      case 3:
        return const Color(0x55005697);
      case 4:
        return const Color(0x66FFCC00);
      case 5:
        return const Color(0x668B5CF6);
      case 6:
        return const Color(0x66FF9900);
      case 7:
        return const Color(0x66FFD700);
      default:
        return const Color(0x668B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.586,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _gradient,
          border: Border.all(
            color: const Color(0x40A78BFA),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _glowColor,
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: Color(0x99000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Soft neon accent illumination curves in background
            Positioned(
              right: -40,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _glowColor.withOpacity(0.25),
                ),
              ),
            ),
            // Card Content Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Bank Badge + Name & Contactless Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          BankLogoWidget(bankName: bankName, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            bankName.isEmpty ? 'Bank Name' : bankName,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const ContactlessIcon(color: Colors.white, size: 18),
                    ],
                  ),

                  // Middle Row: Card Number
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      cardNumber.isEmpty ? '•••• •••• •••• ••••' : cardNumber,
                      style: AppTypography.cardNumber.copyWith(
                        fontSize: isLivePreview ? 17 : 19,
                        letterSpacing: 2.2,
                      ),
                    ),
                  ),

                  // Bottom Row: Details / Network
                  if (isLivePreview)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CARD HOLDER', style: AppTypography.labelUppercase),
                            const SizedBox(height: 2),
                            Text(
                              (cardholderName == null || cardholderName!.isEmpty)
                                  ? 'John Doe'
                                  : cardholderName!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('EXPIRES', style: AppTypography.labelUppercase),
                            const SizedBox(height: 2),
                            Text(
                              (expiryDate == null || expiryDate!.isEmpty)
                                  ? 'MM/YY'
                                  : expiryDate!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        NetworkLogoWidget(network: network),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cardType.toUpperCase() == 'CREDIT' ? 'Credit Card' : 'Debit Card',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        NetworkLogoWidget(network: network),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
