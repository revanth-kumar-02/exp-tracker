import 'package:flutter/material.dart';

/// Centralized color palette strictly conforming to the mandatory
/// dark fintech UI reference specification.
abstract class AppColors {
  // Background & Surfaces
  static const Color background = Color(0xFF0B0B12);
  static const Color surface = Color(0xFF13131F);
  static const Color surfaceElevated = Color(0xFF1B1B2D);
  static const Color cardSurface = Color(0xFF161626);
  static const Color surfaceBorder = Color(0xFF26263B);
  static const Color inputBackground = Color(0xFF161624);
  static const Color inputBorder = Color(0xFF2A2A40);

  // Brand & Violet/Purple Accents
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryAccent = Color(0xFFA78BFA);
  static const Color primaryGlow = Color(0x4D7C3AED);
  static const Color purpleGlowSoft = Color(0x268B5CF6);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activePillGradient = LinearGradient(
    colors: [Color(0xFF2E2452), Color(0xFF1E1738)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Bank Card Visual Gradients
  static const LinearGradient hdfcCardGradient = LinearGradient(
    colors: [Color(0xFF2B194D), Color(0xFF17102E), Color(0xFF0E0A1D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sbiCardGradient = LinearGradient(
    colors: [Color(0xFF112A4E), Color(0xFF0C1B33), Color(0xFF070E1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient iciciCardGradient = LinearGradient(
    colors: [Color(0xFF3E1A1A), Color(0xFF241010), Color(0xFF130808)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Additional User-Selected Bank Gradients
  static const LinearGradient rblCardGradient = LinearGradient(
    colors: [Color(0xFF0F2B5C), Color(0xFF1C1335), Color(0xFF0A0E1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient canaraCardGradient = LinearGradient(
    colors: [Color(0xFF0E3259), Color(0xFF1A2B20), Color(0xFF09141F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sliceCardGradient = LinearGradient(
    colors: [Color(0xFF350A52), Color(0xFF1A052E), Color(0xFF0C0017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amazonPayCardGradient = LinearGradient(
    colors: [Color(0xFF1C2430), Color(0xFF131922), Color(0xFF090D12)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient iobCardGradient = LinearGradient(
    colors: [Color(0xFF003366), Color(0xFF001F3F), Color(0xFF001026)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status & Utility Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color surfaceLight = Color(0xFF1B1B2D);
  static const Color accentSuccess = Color(0xFF10B981);
  static const Color accentWarning = Color(0xFFF59E0B);
  static const Color accentError = Color(0xFFEF4444);
  static const Color accentExpense = Color(0xFFEF4444);

  static const List<LinearGradient> cardGradients = [
    hdfcCardGradient,
    sbiCardGradient,
    iciciCardGradient,
    rblCardGradient,
    canaraCardGradient,
    sliceCardGradient,
    amazonPayCardGradient,
    iobCardGradient,
  ];

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // Indicator & Badge
  static const Color redDot = Color(0xFFEF4444);
  static const Color progressTrack = Color(0xFF232338);
}
