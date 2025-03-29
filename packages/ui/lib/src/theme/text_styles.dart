import 'package:flutter/material.dart';

/// Text styles for the app
class AppTextStyles {
  /// Large display text style, used for titles/bigger headlines
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.02,
    height: 0.9,
  );

  /// Medium display text style, used for headlines
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  /// Medium body text style, used for regular text
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );

  /// Bold medium label text style
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Light text style
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    letterSpacing: 0,
  );
}
