import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/events/view/post_event_screen.dart';
import 'package:actilink/venues/view/post_venue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostChooserScreen extends StatefulWidget {
  const PostChooserScreen({super.key});

  @override
  State<PostChooserScreen> createState() => _PostChooserScreenState();
}

class _PostChooserScreenState extends State<PostChooserScreen> {
  String selectedType = 'Event';

  @override
  Widget build(BuildContext context) {
    final isBusinessClient = context.read<AuthCubit>().isBusinessClient;

    if (!isBusinessClient) {
      return const PostEventScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select post type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
              items: const [
                DropdownMenuItem(value: 'Event', child: Text('Event')),
                DropdownMenuItem(value: 'Venue', child: Text('Venue')),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: selectedType == 'Event'
                  ? const PostEventScreen()
                  : const PostVenueScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
