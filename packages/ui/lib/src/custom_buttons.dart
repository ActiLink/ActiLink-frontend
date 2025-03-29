import 'package:flutter/material.dart';
import 'package:ui/src/theme/app_colors.dart';
import 'package:ui/src/theme/text_styles.dart';

enum ButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final String? label;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primary;
        break;
      case ButtonType.secondary:
        backgroundColor = AppColors.secondary;
        break;
    }

    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(230, 50),
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
        ),
      ],
    );
  }
}
