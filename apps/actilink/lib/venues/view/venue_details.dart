import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class VenueDetailsScreen extends StatelessWidget {
  const VenueDetailsScreen({
    required this.venue,
    super.key,
  });

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(venue.name)),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Address',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              venue.address,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (venue.owner != null) ...[
              const SizedBox(height: 16),
              Text(
                'Owner',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                venue.owner!.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (venue.events.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Upcoming Events',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: venue.events.length,
                itemBuilder: (context, index) {
                  final event = venue.events[index];
                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.description),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}