import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/auth/view/register_modal.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _formKey = GlobalKey<FormState>();
  late String? _email;
  late String? _password;
  bool _obscurePassword = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Welcome back, ${state.user.name}!')),
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
                      'Sign into your account',
                      style: AppTextStyles.displayMedium,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign in to continue your journey with ActiLink.',
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
                  ],
                ),
                Column(
                  children: [
                    AppButton(
                      text: isLoading ? 'Signing In...' : 'Sign In',
                      onPressed: isLoading ? () {} : _tryLogin,
                    ),

                    const SizedBox(height: 10),

                    /// Navigate to Register Screen
                    AppButton(
                      text: "Don't have an account?",
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(Duration.zero, () {
                          if (context.mounted) {
                            // Show the register modal
                            showCustomBottomSheet(
                              context,
                              const RegisterModal(),
                            );
                          }
                        });
                      },
                      type: ButtonType.text,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _tryLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_email != null && _password != null) {
        context.read<AuthCubit>().login(
              email: _email!,
              password: _password!,
            );
      }
    }
  }
}
