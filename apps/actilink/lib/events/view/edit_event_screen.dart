import 'package:actilink/events/view/widgets/event_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditEventScreen extends StatelessWidget {
  const EditEventScreen({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return EventForm(
      event: event,
      onSubmit: (updatedEvent) {
        context.go('/events/details/${event.id}', extra: event);
      },
    );
  }
}
