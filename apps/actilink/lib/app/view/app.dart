import 'package:actilink/app/environment.dart';
import 'package:actilink/app/view/app_startup.dart';
import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
import 'package:actilink/l10n/l10n.dart';
import 'package:actilink/router.dart';
import 'package:actilink/venues/logic/venues_cubit.dart';
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
          create: (context) =>
              ApiService(baseUrl: 'https://10.0.2.2:5289/', apiVersion: 'v1'),
        ),
        RepositoryProvider(
          create: (context) => BaseUserRepository(
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
          create: (context) => VenueRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => AuthService(
            apiService: context.read<ApiService>(),
            tokenRepository: context.read<AuthTokenRepository>(),
            baseUserRepository: context.read<BaseUserRepository>(),
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
          BlocProvider(
            create: (context) => VenuesCubit(
              venueRepository: context.read<VenueRepository>(),
            )..fetchVenues(),
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
