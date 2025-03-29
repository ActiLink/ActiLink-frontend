import 'package:actilink/login/view/login_page.dart';
import 'package:actilink/login/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui/ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void showBottomSheet(BuildContext context, Widget screen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return screen;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset('assets/welcome.svg', width: 200, height: 200),
              Column(
                children: [
                  Text(
                    'Welcome to ActiLink!',
                    style: AppTextStyles.displayLarge
                        .copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    child: Text(
                      'Find like-minded people, join events, and enjoy your passions together. Let the adventure begin!',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  AppButton(
                    text: "Get started",
                    onPressed: () =>
                        showBottomSheet(context, const RegisterScreen()),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    text: "I already have an account",
                    onPressed: () =>
                        showBottomSheet(context, const LoginScreen()),
                    type: ButtonType.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
