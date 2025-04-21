import 'package:actilink/events/view/event_details.dart';
import 'package:actilink/events/view/widgets/event_form.dart';
import 'package:actilink/home/main_screen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:actilink/home/home_screen.dart';
import 'package:actilink/events/view/events_screen.dart';
import 'package:actilink/events/view/post_event_screen.dart';
import 'package:actilink/home/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
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
                final id = state.pathParameters['id']!;
                final event =
                    state.extra as Event; // Upewnij się, że przekazujesz Event
                return EventDetailsScreen(event: event);
              },
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                final eventId = state.pathParameters['id']; // id wydarzenia
                final event =
                    state.extra as Event?; // Przekazywany event, może być null
                return EventForm(
                  event: event, // Przekazujemy event, jeśli istnieje
                  onSubmit: (updatedEvent) {
                    context.pop(updatedEvent); // Zwracamy zaktualizowany event
                  },
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
