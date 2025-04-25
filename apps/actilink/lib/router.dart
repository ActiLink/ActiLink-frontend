import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:actilink/events/view/event_details.dart';
import 'package:actilink/events/view/events_screen.dart';
import 'package:actilink/events/view/post_event_screen.dart';
import 'package:actilink/events/view/widgets/event_form.dart';
import 'package:actilink/home/home_screen.dart';
import 'package:actilink/home/main_shell.dart';
import 'package:actilink/home/profile_screen.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;

    final isLoggingIn = state.uri.path == '/welcome';
    final isAuthenticated = authState is AuthAuthenticated;

    if (!isAuthenticated && !isLoggingIn) {
      return '/welcome';
    }

    if (isAuthenticated && isLoggingIn) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsScreen(),
          routes: [
            GoRoute(
              path: 'details/:id',
              builder: (context, state) {
                final event = state.extra! as Event;
                return EventDetailsScreen(event: event);
              },
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                final event = state.extra as Event?;
                return EventForm(
                  event: event,
                  onSubmit: (updatedEvent) => context.pop(updatedEvent),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/post',
          builder: (context, state) => const PostEventScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const HomeScreen(), // placeholder
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
