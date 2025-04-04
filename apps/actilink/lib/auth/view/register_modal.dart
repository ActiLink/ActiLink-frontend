import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/auth/view/login_modal.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final _formKey = GlobalKey<FormState>();
  late String? _email;
  late String? _username;
  late String? _password;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Welcome, ${state.user.name}!')),
            );
        } else if (state is AuthFailure) {
          errorMessage = state.error;
          context.read<AuthCubit>().resetAuthStateAfterFailure();
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Column(
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

                    /// Error Message
                    if (errorMessage != null) ...[
                      Text(
                        errorMessage!,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                    ],

                    /// Email Field
                    AppTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
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
                      validator: _validatePassword,
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
                  ],
                ),

                const SizedBox(height: 20),

                /// Register Button with Loading State
                Column(
                  children: [
                    AppButton(
                      text: isLoading ? 'Signing Up...' : 'Sign Up',
                      onPressed: isLoading ? () {} : _tryRegisterAndLogin,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

                AppButton(
                  text: 'Already have an account?',
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(Duration.zero, () {
                      if (context.mounted) {
                        // Show the login modal
                        showCustomBottomSheet(context, const LoginModal());
                      }
                    });
                  },
                  type: ButtonType.text,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _tryRegisterAndLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_username != null && _email != null && _password != null) {
        context.read<AuthCubit>().registerAndLogin(
              name: _username!,
              email: _email!,
              password: _password!,
            );
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    // RegExp for uppercase letter
    if (!RegExp('[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter.';
    }
    // RegExp for lowercase letter
    if (!RegExp('[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter.';
    }
    // RegExp for digit
    if (!RegExp('[0-9]').hasMatch(value)) {
      return 'Password must contain a digit.';
    }
    // RegExp for non-alphanumeric character (symbol)
    // This matches common symbols like !@#$%^&*()_+-=[]{};':"\|,.<>/?~`
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      // Simplified common symbols check. Adjust regex if specific symbols are needed/excluded.
      // Alternatively, you can check for absence of only letters and numbers:
      // if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Password must contain a non-alphanumeric character.';
      // }
    }
    // All checks passed
    return null;
  }
}
