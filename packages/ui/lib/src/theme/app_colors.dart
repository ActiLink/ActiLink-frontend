import 'package:flutter/material.dart';

/// Harmonized, semantic color palette for the app.
class AppColors {
  // === Brand Colors ===
  static const Color brand = Color(0xFF6438CB); // Primary purple
  static const Color accent = Color(0xFF9A98EB); // Soft purple highlight
  static const Color highlight = Color(0xFFECF994); // CTA yellow

  // === UI Base ===
  static const Color background =
      Color(0xFFF5F4FA); // Soft off-white with purple tint
  static const Color surface = Color(0xFFFFFFFF); // White cards, modals, sheets
  static const Color border =
      Color(0xFFE2E0F0); // Very light purple-grey for outlines

  // === Text ===
  static const Color textPrimary = Color(0xFF2A1A5E); // Deep purple-black
  static const Color textSecondary = Color(0xFF5E4B9A); // Muted purple
  static const Color textDisabled =
      Color(0xFFB5AED7); // Faded lavender for hint/disabled

  // === Status Colors (Purple-toned versions) ===
  static const Color success =
      Color(0xFF6DD3B3); // Minty green (less aggressive)
  static const Color warning = Color(0xFFF2E16A); // Soft warm yellow
  static const Color error = Color(0xFFD77A89); // Muted rose
  static const Color info = Color(0xFF8E9AE6); // Soft bluish purple

  // === Utility ===
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
