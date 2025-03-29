import 'package:flutter/material.dart';
import 'package:ui/src/theme/app_colors.dart';
import 'package:ui/src/theme/text_styles.dart';

class AppTextField extends StatelessWidget { // <-- Added suffixIcon

  const AppTextField({
    required this.label, required this.hintText, super.key,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator, // <-- Validator parameter
    this.onChanged, // <-- onChanged parameter
    this.suffixIcon, // <-- SuffixIcon parameter
  });
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // <-- Added validator
  final ValueChanged<String>? onChanged; // <-- Added onChanged
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator, // <-- Apply validator
          onChanged: onChanged, // <-- Apply onChanged
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
            filled: true,
            fillColor: AppColors.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            suffixIcon: suffixIcon, // <-- Apply suffixIcon here
          ),
        ),
      ],
    );
  }
}
