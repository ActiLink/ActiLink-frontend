import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  'Sign into your account',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign in to continue your journey with ActiLink.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextField(label: "Username", hintText: ""),
                const AppTextField(
                  label: "Password",
                  hintText: "",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AppButton(text: 'Sign In', onPressed: () => {}),
                const SizedBox(height: 10),
                AppButton(
                  text: "Don't have an account?",
                  onPressed: () => {},
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
