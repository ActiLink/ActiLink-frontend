import 'package:flutter/material.dart';
import 'package:ui/src/theme/app_colors.dart';
import 'package:ui/src/theme/text_styles.dart';

enum ButtonType { primary, secondary, text } // Added text button type

class AppButton extends StatelessWidget {

  const AppButton({
    required this.text, required this.onPressed, super.key,
    this.type = ButtonType.primary,
    this.label,
  });
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.text) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
        ),
      );
    }

    final backgroundColor =
        (type == ButtonType.primary) ? AppColors.primary : AppColors.secondary;

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
      child: Text(
        text,
        style: type == ButtonType.secondary
            ? AppTextStyles.bodyMedium.copyWith(color: AppColors.black)
            : AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
      ),
    );
  }
}
