import 'package:actilink/auth/view/register_modal.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:actilink/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  bool _obscurePassword = true;
  bool _isLoading = false;
  void _tryLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: replace with actual login
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
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
                  const SizedBox(height: 20),

                  /// Username Field
                  AppTextField(
                    label: 'Username',
                    hintText: 'Enter your username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required.';
                      }
                      return null;
                    },
                    onChanged: (value) => _username = value,
                  ),

                  /// Password Field with Visibility Toggle
                  AppTextField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required.';
                      }
                      return null;
                    },
                    onChanged: (value) => _password = value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Sign In Button with Loading State
                  AppButton(
                    text: _isLoading ? 'Signing In...' : 'Sign In',
                    onPressed: _isLoading ? () {} : _tryLogin,
                  ),

                  const SizedBox(height: 10),

                  /// Navigate to Register Screen
                  AppButton(
                    text: "Don't have an account?",
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(Duration.zero, () {
                        showCustomBottomSheet(context, const RegisterModal());
                      });
                    },
                    type: ButtonType.text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
