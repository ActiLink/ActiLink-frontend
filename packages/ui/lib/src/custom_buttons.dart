import 'package:flutter/material.dart';
import 'package:ui/src/theme/app_colors.dart';
import 'package:ui/src/theme/text_styles.dart';

/// Enum to represent the type of button.
enum ButtonType {
  /// A primary button with the main color.
  primary,

  /// A secondary button with a neutral color.
  secondary,

  /// A text button with no background, usually for simple actions.
  text
}

/// A custom button widget used throughout the app, which supports
/// different button types and styles.
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  ///
  /// The [text] parameter is required to display the button label,
  /// the [onPressed] callback is required for the button action,
  /// the [type] determines the button style (defaults to [ButtonType.primary]),
  /// the [label] is an optional label text, and
  /// the [child] is an widget that takes precedence over text if provided.
  const AppButton({
    required this.onPressed,
    super.key,
    this.text = '',
    this.type = ButtonType.primary,
    this.label,
    this.child,
  }) : assert(
          text != '' || child != null,
          'Either text or child must be provided',
        );

  /// The text to display on the button.
  final String text;

  /// The callback function that is triggered when the button is pressed.
  final VoidCallback onPressed;

  /// The type of button (primary, secondary, or text).
  final ButtonType type;

  /// An optional label to display, specific to the button style.
  final String? label;

  /// An optional child widget to display instead of the text.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.text) {
      // Returns a text button with custom styling
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: child ??
            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.brand),
            ),
      );
    }

    // Default background color based on button type (primary or secondary)
    final backgroundColor =
        (type == ButtonType.primary) ? AppColors.highlight : AppColors.white;

    // Returns an elevated button with custom styling
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(300, 50),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      onPressed: onPressed,
      child: child ??
          Text(
            text,
            style: type == ButtonType.secondary
                ? AppTextStyles.bodyMedium.copyWith(color: AppColors.black)
                : AppTextStyles.bodyMedium.copyWith(color: AppColors.black),
          ),
    );
  }
}
