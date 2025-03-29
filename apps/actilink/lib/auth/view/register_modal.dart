import 'package:actilink/auth/view/login_modal.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _username;
  String? _password;
  String? _confirmPassword;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _tryRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: replace with actual registration
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Navigator.pop(context);
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
                    'Create an Account',
                    style: AppTextStyles.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Join ActiLink and start your adventure today!',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 20),

                  /// Email Field
                  AppTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required.';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                    onChanged: (value) => _email = value,
                  ),

                  /// Username Field
                  AppTextField(
                    label: 'Username',
                    hintText: 'Choose a username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required.';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters.';
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
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters.';
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

                  /// Confirm Password Field
                  AppTextField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      }
                      if (value != _password) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    onChanged: (value) => _confirmPassword = value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Register Button with Loading State
                  AppButton(
                    text: _isLoading ? 'Signing Up...' : 'Sign Up',
                    onPressed: _isLoading
                        ? () {}
                        : _tryRegister, // Pass empty function when loading
                  ),

                  const SizedBox(height: 10),

                  AppButton(
                    text: 'Already have an account?',
                    onPressed: () {
                      Navigator.pop(context); // Close the current modal
                      Future.delayed(Duration.zero, () {
                        showCustomBottomSheet(context, const LoginModal());
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
