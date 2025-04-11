import 'package:actilink/events/events_data.dart';
import 'package:actilink/events/view/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sampleEvents.length,
        itemBuilder: (context, index) {
          final event = sampleEvents[index];
          return EventCard(event: event);
        },
      ),
    );
  }
}
