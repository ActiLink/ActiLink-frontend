import 'dart:developer';

import 'package:actilink/auth/auth.dart';
import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/home/main_screen.dart';
import 'package:actilink/l10n/l10n.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider(
          create: (context) => ApiService(baseUrl: 'https://10.0.2.2:5289'),
        ),
        Provider(
          create: (context) => UserRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        Provider(
          create: (context) => AuthTokenRepository(
            secureStorage: const FlutterSecureStorage(),
          ),
        ),
        Provider(
          create: (context) => AuthService(
            apiService: context.read<ApiService>(),
            tokenRepository: context.read<AuthTokenRepository>(),
            userRepository: context.read<UserRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            authService: context.read<AuthService>(),
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            log('App BlocBuilder: AuthState = ${state.runtimeType}');

            return state is AuthAuthenticated
                ? const MainScreen()
                : const WelcomeScreen();
          },
        ),
      ),
    );
  }
}
