import 'package:flutter/material.dart';
import 'package:ui/src/theme/app_colors.dart';
import 'package:ui/src/theme/text_styles.dart';

class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  ///
  /// The [label] is the text displayed above the text field,
  /// [hintText] is the placeholder text shown inside the field,
  /// [controller] is the optional controller for the text field,
  /// [obscureText] determines if the text should be obscured (for password),
  /// [keyboardType] defines the type of keyboard (e.g., text, number),
  /// [validator] is used for form validation,
  /// [onChanged] is a callback for when the text field value changes,
  /// [suffixIcon] is an optional widget displayed at the end of text field,
  /// [multiline] determines if the text field should support multiple lines,
  /// [labelStyle] allows customizing the style of the label text.
  const AppTextField({
    required this.label,
    required this.hintText,
    super.key,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.multiline = false,
    this.labelStyle,
  });

  /// The label text that appears above the text field.
  final String label;

  /// The hint text that appears inside the text field as a placeholder.
  final String hintText;

  /// The controller that manages the text input.
  final TextEditingController? controller;

  /// Determines whether the text should be obscured (typically for password).
  final bool obscureText;

  /// Defines the type of keyboard to display (e.g., text, number, email).
  final TextInputType keyboardType;

  /// A function to validate the text field input.
  final String? Function(String?)? validator;

  /// A callback function that triggers when the text field value changes.
  final ValueChanged<String>? onChanged;

  /// An optional widget (e.g., icon) displayed at the end of the text field.
  final Widget? suffixIcon;

  /// Determines whether the text field should support multiple lines of text.
  final bool multiline;

  /// Custom style for the label text.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display label
          Text(
            label,
            style: labelStyle ??
                AppTextStyles.bodySmall.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 4),

          // The actual text field
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            maxLines: multiline ? null : 1,
            minLines: multiline ? 3 : 1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
