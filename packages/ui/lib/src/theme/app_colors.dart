import 'package:flutter/material.dart';

/// Color palette for the app.
class AppColors {
  // === Brand Colors ===

  /// Primary brand color – a bold purple used for main elements.
  static const Color brand = Color(0xFF6438CB);

  /// Accent color – a soft purple used for highlights and secondary accents.
  static const Color accent = Color(0xFF9A98EB);

  /// Highlight color – a bright yellow used for call-to-action elements.
  static const Color highlight = Color(0xFFECF994);

  // === UI Base ===

  /// Background color – a soft off-white with a slight purple tint.
  static const Color background = Color(0xFFF5F4FA);

  /// Surface color – pure white, used for cards, modals, and sheets.
  static const Color surface = Color(0xFFFFFFFF);

  /// Border color – a very light purple-grey used for outlines and dividers.
  static const Color border = Color(0xFFE2E0F0);

  // === Text ===

  /// Primary text color – deep purple-black for high readability.
  static const Color textPrimary = Color(0xFF2A1A5E);

  /// Secondary text color – a muted purple for less emphasized text.
  static const Color textSecondary = Color(0xFF5E4B9A);

  /// Disabled text color – a faded lavender used for hint or disabled text.
  static const Color textDisabled = Color(0xFFB5AED7);

  // === Status Colors (Purple-toned versions) ===

  /// Success color – a minty green for positive feedback or confirmation.
  static const Color success = Color(0xFF6DD3B3);

  /// Warning color – a soft warm yellow to signal caution.
  static const Color warning = Color(0xFFF2E16A);

  /// Error color – a muted rose for error messages and negative states.
  static const Color error = Color(0xFFD77A89);

  /// Info color – a soft bluish purple for informative messages.
  static const Color info = Color(0xFF8E9AE6);

  // === Utility ===

  /// Pure white color utility.
  static const Color white = Colors.white;

  /// Pure black color utility.
  static const Color black = Colors.black;
}
