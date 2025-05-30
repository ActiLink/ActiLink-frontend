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
import 'package:flutter_test/flutter_test.dart';

/// A testing utility function that creates the App with the ability
/// to override repositories and cubits for testing purposes.
extension PumpApp on WidgetTester {
  Future<void> pumpApp({
    // Repository overrides
    FlutterSecureStorage? secureStorage,
    AuthTokenRepository? authTokenRepository,
    ApiService? apiService,
    BaseUserRepository? baseUserRepository,
    EventRepository? eventRepository,
    HobbyRepository? hobbyRepository,
    VenueRepository? venueRepository,
    AuthService? authService,
    GoogleMapsService? googleMapsService,

    // Cubit overrides
    AuthCubit? authCubit,
    EventsCubit? eventsCubit,
    HobbiesCubit? hobbiesCubit,
    VenuesCubit? venuesCubit,
  }) async {
    // Create repository providers with passed mocks or real instances
    final repositoryProviders = [
      RepositoryProvider<FlutterSecureStorage>(
        create: (_) => secureStorage ?? const FlutterSecureStorage(),
      ),
      RepositoryProvider<AuthTokenRepository>(
        create: (context) =>
            authTokenRepository ??
            AuthTokenRepository(
              secureStorage: context.read<FlutterSecureStorage>(),
            ),
      ),
      RepositoryProvider<ApiService>(
        create: (_) =>
            apiService ??
            ApiService(
              baseUrl: 'https://10.0.2.2:5289/',
              apiVersion: 'v1',
            ),
      ),
      RepositoryProvider<BaseUserRepository>(
        create: (context) =>
            baseUserRepository ??
            BaseUserRepository(
              apiService: context.read<ApiService>(),
            ),
      ),
      RepositoryProvider<EventRepository>(
        create: (context) =>
            eventRepository ??
            EventRepository(
              apiService: context.read<ApiService>(),
            ),
      ),
      RepositoryProvider<HobbyRepository>(
        create: (context) =>
            hobbyRepository ??
            HobbyRepository(
              apiService: context.read<ApiService>(),
            ),
      ),
      RepositoryProvider<VenueRepository>(
        create: (context) =>
            venueRepository ??
            VenueRepository(
              apiService: context.read<ApiService>(),
            ),
      ),
      RepositoryProvider<AuthService>(
        create: (context) =>
            authService ??
            AuthService(
              apiService: context.read<ApiService>(),
              tokenRepository: context.read<AuthTokenRepository>(),
              baseUserRepository: context.read<BaseUserRepository>(),
            ),
      ),
      RepositoryProvider<GoogleMapsService>(
        create: (_) =>
            googleMapsService ??
            GoogleMapsService(apiKey: Environment.kGoogleMapsAPI),
      ),
    ];

    // Create cubit providers with passed mocks or real instances
    final blocProviders = [
      BlocProvider<AuthCubit>(
        create: (context) =>
            authCubit ??
            AuthCubit(
              authService: context.read<AuthService>(),
            ),
      ),
      BlocProvider<EventsCubit>(
        create: (context) =>
            eventsCubit ??
            EventsCubit(
              eventRepository: context.read<EventRepository>(),
            ),
      ),
      BlocProvider<HobbiesCubit>(
        create: (context) =>
            hobbiesCubit ??
            HobbiesCubit(
              hobbyRepository: context.read<HobbyRepository>(),
            ),
      ),
      BlocProvider<VenuesCubit>(
        create: (context) =>
            venuesCubit ??
            VenuesCubit(
              venueRepository: context.read<VenueRepository>(),
            ),
      ),
    ];

    // Pump the app with the specified providers
    return pumpWidget(
      MultiRepositoryProvider(
        providers: repositoryProviders,
        child: MultiBlocProvider(
          providers: blocProviders,
          child: AppStartup(
            child: MaterialApp.router(
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                ),
                useMaterial3: true,
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      ),
    );
  }
}
