import 'package:actilink/app/environment.dart';
import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
import 'package:actilink/l10n/l10n.dart';
import 'package:actilink/router.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => const FlutterSecureStorage(),
        ),
        RepositoryProvider(
          create: (context) => AuthTokenRepository(
            secureStorage: context.read<FlutterSecureStorage>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ApiService(baseUrl: 'https://10.0.2.2:5289/'),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => EventRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => HobbyRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => AuthService(
            apiService: context.read<ApiService>(),
            tokenRepository: context.read<AuthTokenRepository>(),
            userRepository: context.read<UserRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) =>
              GoogleMapsService(apiKey: Environment.kGoogleMapsAPI),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authService: context.read<AuthService>(),
            ),
          ),
          BlocProvider(
            create: (context) => EventsCubit(
              eventRepository: context.read<EventRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HobbiesCubit(
              hobbyRepository: context.read<HobbyRepository>(),
            ),
          ),
        ],
        child: AppStartup(
          child: MaterialApp.router(
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authCubit = context.read<AuthCubit>();
    final eventsCubit = context.read<EventsCubit>();
    final hobbiesCubit = context.read<HobbiesCubit>();

    // Initialize the auth interceptor
    context.read<ApiService>().addInterceptor(
          AuthInterceptor(
            tokenRepository: context.read<AuthTokenRepository>(),
            authService: context.read<AuthService>(),
          ),
        );

    // Initialize all required data
    await authCubit.checkAuthStatus();
    if (authCubit.state is AuthAuthenticated) {
      await eventsCubit.fetchEvents();
      await hobbiesCubit.fetchHobbies();
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Fetch data whenever auth state changes to authenticated
          context.read<EventsCubit>().fetchEvents();
          context.read<HobbiesCubit>().fetchHobbies();
        }
      },
      child: widget.child,
    );
  }
}
