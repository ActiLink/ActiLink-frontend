import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final venuesCubit = context.read<VenuesCubit>();

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
      await venuesCubit.fetchVenues();
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

    return widget.child;
  }
}
