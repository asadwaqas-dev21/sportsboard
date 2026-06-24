import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

/// Typography scale for SportsBoard using Google Fonts (Inter).
abstract class AppTextStyles {
  // ── Display ──
  static TextStyle displayLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
        height: 1.25,
      );

  // ── Headline ──
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.35,
      );

  static TextStyle headlineSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.35,
      );

  // ── Title ──
  static TextStyle titleLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      );

  // ── Body ──
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  // ── Label ──
  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.2,
        height: 1.4,
      );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.3,
        height: 1.4,
      );

  // ── Score / Stats ──
  static TextStyle scoreDisplay({Color? color}) => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -1,
      );

  static TextStyle scoreLarge({Color? color}) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle scoreMedium({Color? color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
      );
}
