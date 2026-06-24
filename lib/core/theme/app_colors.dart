import "package:flutter/material.dart";

/// Navy & Green color palette for SportsBoard matching UniSports Hub.
abstract class AppColors {
  // ── Primary (Navy Blue) ──
  static const Color primary = Color(0xFF0F1E36);
  static const Color primaryLight = Color(0xFF1E3250);
  static const Color primaryDark = Color(0xFF070F1C);
  static const Color primarySurface = Color(0xFFE8EEF5);

  // ── Accent (Green) ──
  static const Color accent = Color(0xFF28A745);
  static const Color accentLight = Color(0xFF4AC264);
  static const Color accentDark = Color(0xFF1E7A32);

  // ── Semantic ──
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // ── Neutral — Light Mode ──
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE9ECEF);
  static const Color textPrimaryLight = Color(0xFF0F1E36); // Navy for primary text
  static const Color textSecondaryLight = Color(0xFF6C757D);
  static const Color textTertiaryLight = Color(0xFFADB5BD);

  // ── Neutral — Dark Mode ──
  // (Optional: Adjust dark mode if requested later, keeping it consistent for now)
  static const Color backgroundDark = Color(0xFF070F1C);
  static const Color surfaceDark = Color(0xFF0F1E36);
  static const Color cardDark = Color(0xFF162742);
  static const Color dividerDark = Color(0xFF2A3C56);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFADB5BD);
  static const Color textTertiaryDark = Color(0xFF6C757D);

  // ── Gradients (Legacy Support for IDE Caching) ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Sport Accent Colors ──
  static const Color cricketGreen = Color(0xFF28A745);
  static const Color footballPitch = Color(0xFF1E7A32);
  static const Color badmintonBlue = Color(0xFF17A2B8);
  static const Color indoorPurple = Color(0xFF6F42C1);
  static const Color athleticsOrange = Color(0xFFFD7E14);
  static const Color volleyballYellow = Color(0xFFFFC107);
  static const Color tableTennisRed = Color(0xFFDC3545);
  static const Color chessGold = Color(0xFFFFC107);

  /// Returns the accent color for a given sport type key.
  static Color sportColor(String sportKey) {
    switch (sportKey) {
      case "cricket":
        return cricketGreen;
      case "football":
        return footballPitch;
      case "badminton":
        return badmintonBlue;
      case "table_tennis":
        return tableTennisRed;
      case "volleyball":
        return volleyballYellow;
      case "chess":
        return chessGold;
      case "athletics":
        return athleticsOrange;
      default:
        return indoorPurple;
    }
  }
}
