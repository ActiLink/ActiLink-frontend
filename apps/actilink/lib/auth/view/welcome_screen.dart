import 'package:actilink/app/flags.dart';
import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/auth/view/select_user_type_modal_register.dart';
import 'package:actilink/auth/view/selet_user_type_modal_login.dart';
import 'package:actilink/auth/widgets/custom_bottom_sheet.dart';
import 'package:actilink/dev/dev_tools_button.dart' show DevToolsButton, kIsDev;
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<EventsCubit>().fetchEvents();
          context.read<HobbiesCubit>().fetchHobbies();
          context.read<VenuesCubit>().fetchVenues();
          context.go('/events');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          // Wrapped with Stack
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.brand, Color.fromARGB(255, 149, 118, 221)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        'assets/welcome.svg',
                        width: 200,
                        height: 200,
                      ),
                      Column(
                        children: [
                          Text(
                            'Welcome to ActiLink!',
                            style: AppTextStyles.displayLarge
                                .copyWith(color: AppColors.white),
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
                                  .copyWith(color: AppColors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          AppButton(
                            text: 'Get started',
                            onPressed: () => showCustomBottomSheet(
                              context,
                              const SelectUserTypeModalRegister(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          AppButton(
                            text: 'I already have an account',
                            onPressed: () => showCustomBottomSheet(
                              context,
                              const SelectUserTypeModalLogin(),
                            ),
                            type: ButtonType.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (kIsDev) const DevToolsButton(),
          ],
        ),
      ),
    );
  }
}
