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
    return VenueForm(
      venue: venue,
      onSubmit: (updatedVenue) async {
        context.read<VenuesCubit>();

        if (!context.mounted) return;

        context.pop(updatedVenue);
            },
    );
  }
}
