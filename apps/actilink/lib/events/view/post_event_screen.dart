import 'package:actilink/events/view/widgets/event_form.dart';
import 'package:flutter/material.dart';

class PostEventScreen extends StatelessWidget {
  const PostEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EventForm(onSubmit: (event) {});
  }
}
