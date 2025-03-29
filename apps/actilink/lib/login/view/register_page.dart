import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Create an Account',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Join ActiLink and start your adventure today!',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 20),
                AppTextField(label: "Full Name", hintText: ""),
                const AppTextField(label: "Email", hintText: ""),
                const AppTextField(label: "Username", hintText: ""),
                const AppTextField(
                  label: "Password",
                  hintText: "",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AppButton(text: 'Sign Up', onPressed: () => {}),
                const SizedBox(height: 10),
                AppButton(
                  text: "Already have an account?",
                  onPressed: () => Navigator.pop(context),
                  type: ButtonType.text,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
