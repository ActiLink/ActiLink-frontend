import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:actilink/venues/view/widgets/venue_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditVenueScreen extends StatelessWidget {
  const EditVenueScreen({
    required this.venue,
    super.key,
  });

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Venue'),
      ),
      body: VenueForm(
        venue: venue,
        onSubmit: (updatedVenue) async {
          final success = await context
              .read<VenuesCubit>()
              .updateVenue(venue.id, updatedVenue);

          if (!context.mounted) return;

          if (success) {
            context.pop(updatedVenue);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update venue')),
            );
          }
        },
      ),
    );
  }
}
