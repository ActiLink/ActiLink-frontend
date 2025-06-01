import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:actilink/events/view/event_details.dart';
import 'package:actilink/events/view/events_screen.dart';
import 'package:actilink/events/view/widgets/event_form.dart';
import 'package:actilink/home/home_screen.dart';
import 'package:actilink/home/main_shell.dart';
import 'package:actilink/post_chooser_screen.dart';
import 'package:actilink/profile/view/edit_hobbies_screen.dart';
import 'package:actilink/profile/view/edit_profile_screen.dart';
import 'package:actilink/profile/view/profile_screen.dart';
import 'package:actilink/venues/view/edit_venue_screen.dart';
import 'package:actilink/venues/view/venue_details.dart';
import 'package:actilink/venues/view/venues_screen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/events',
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final isLoggingIn = state.uri.path == '/welcome';
    final isAuthenticated = authState is AuthAuthenticated;

    if (!isAuthenticated && !isLoggingIn) {
      return '/welcome';
    }

    if (isAuthenticated && isLoggingIn) {
      return '/events';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsScreen(),
          routes: [
            GoRoute(
              path: 'details/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final data = state.extra! as Map<String, dynamic>;
                return EventDetailsScreen(
                  event: data['event'] as Event,
                  fromVenueDetails: data['fromVenueDetails'] as bool? ?? false,
                );
              },
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: _rootNavigatorKey,
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
          path: '/venues',
          builder: (context, state) => const VenuesScreen(),
          routes: [
            GoRoute(
              path: 'details/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final venue = state.extra! as Venue;
                return VenueDetailsScreen(venue: venue);
              },
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final venue = state.extra! as Venue;
                return EditVenueScreen(venue: venue);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/post',
          builder: (context, state) => const PostChooserScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const EditProfileScreen(),
              routes: [
                GoRoute(
                  path: 'hobbies',
                  builder: (context, state) => const EditHobbiesScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
