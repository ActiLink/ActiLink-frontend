import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/events_state.dart';
import 'package:actilink/events/view/widgets/event_card.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  bool _isUserEnrolled(BaseUser? user, Event event) {
    if (user == null || event.participants == null) return false;
    return event.participants!.any((participant) => participant.id == user.id);
  }

  @override
  Widget build(BuildContext context) {
    final eventCubit = context.read<EventsCubit>();
    final currentUser = context.read<AuthCubit>().user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state.status == EventsStatus.loading && state.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == EventsStatus.failure &&
              state.events.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load events',
                      style: AppTextStyles.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
                      onPressed: eventCubit.fetchEvents,
                    ),
                  ],
                ),
              ),
            );
          } else if (state.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No events found.\nWhy not post one?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh'),
                    onPressed: eventCubit.fetchEvents,
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: eventCubit.fetchEvents,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  final isEnrolled = _isUserEnrolled(currentUser, event);
                  return EventCard(
                    event: event,
                    isEnrolled: isEnrolled,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
