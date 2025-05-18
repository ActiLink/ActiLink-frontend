import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:actilink/venues/view/widgets/venue_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostVenueScreen extends StatelessWidget {
  const PostVenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VenueForm(
      onSubmit: (venue) async {
        final venuesCubit = context.read<VenuesCubit>();
        final isEditing = venue.id.isNotEmpty;

        final success = isEditing
            ? await venuesCubit.updateVenue(venue.id, venue)
            : await venuesCubit.addVenue(venue);

        if (success && context.mounted) {
          context.go('/venues');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save venue')),
          );
        }
      },
    );
  }
}
