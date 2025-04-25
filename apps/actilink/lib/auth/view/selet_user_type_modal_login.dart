// lib/auth/view/select_user_type_modal_login.dart
import 'package:actilink/auth/view/select_user_type_modal_register.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:actilink/auth/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:actilink/auth/view/login_modal.dart';
import 'package:actilink/auth/view/register_modal.dart';
import 'package:ui/ui.dart';

class SelectUserTypeModalLogin extends StatelessWidget {
  const SelectUserTypeModalLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome Back',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'What type of account would you like to sign into?',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          /// Regular User Login
          AppButton(
            text: 'Regular User',
            onPressed: () {
              Navigator.pop(context);
              showCustomBottomSheet(
                context,
                const LoginModal(isBusiness: false),
                initialSize: 0.85,
                maxSize: 0.9,
              );
            },
          ),
          const SizedBox(height: 12),

          /// Business Account Login
          AppButton(
            text: 'Business Account',
            onPressed: () {
              Navigator.pop(context);
              showCustomBottomSheet(
                context,
                const LoginModal(isBusiness: true),
                backgroundColor: AppColors.accent,
                initialSize: 0.95,
                maxSize: 0.98,
              );
            },
            type: ButtonType.secondary,
          ),
          const SizedBox(height: 16),

          /// Link to registration
          AppButton(
            text: 'I don’t have an account',
            onPressed: () {
              Navigator.pop(context);
              showCustomBottomSheet(
                context,
                const SelectUserTypeModalRegister(),
              );
            },
            type: ButtonType.text,
          ),
        ],
      ),
    );
  }
}
