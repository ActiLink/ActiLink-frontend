// lib/auth/view/select_user_type_modal.dart
import 'package:actilink/auth/view/register_modal.dart';
import 'package:actilink/auth/view/selet_user_type_modal_login.dart';
import 'package:actilink/auth/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class SelectUserTypeModalRegister extends StatelessWidget {
  const SelectUserTypeModalRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create an Account',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'What type of account would you like to create?',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          AppButton(
            text: 'Regular User',
            onPressed: () {
              Navigator.pop(context); // Close current modal
              showCustomBottomSheet(
                context,
                const RegisterModal(
                  
                ),
                initialSize: 0.85,
                maxSize: 0.9,
              );
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'Business Account',
            onPressed: () {
              Navigator.pop(context);
              showCustomBottomSheet(
                context,
                const RegisterModal(
                  isBusiness: true,
                ),
                backgroundColor: AppColors.accent,
                initialSize: 0.95,
                maxSize: 0.98,
              );
            },
            type: ButtonType.secondary,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'I already have an account',
            onPressed: () {
              Navigator.pop(context);
              showCustomBottomSheet(context, const SelectUserTypeModalLogin());
            },
            type: ButtonType.text,
          ),
        ],
      ),
    );
  }
}
