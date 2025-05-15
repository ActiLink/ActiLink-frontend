import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:actilink/venues/logic/venues_state.dart';
import 'package:actilink/venues/view/widgets/venue_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final venuesCubit = context.read<VenuesCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<VenuesCubit, VenuesState>(
        builder: (context, state) {
          if (state.status == VenuesStatus.loading && state.venues.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == VenuesStatus.failure &&
              state.venues.isEmpty) {
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
                      'Failed to load venues',
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
                      onPressed: venuesCubit.fetchVenues,
                    ),
                  ],
                ),
              ),
            );
          } else if (state.venues.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No venues found.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh'),
                    onPressed: venuesCubit.fetchVenues,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: venuesCubit.fetchVenues,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.venues.length,
              itemBuilder: (context, index) {
                final venue = state.venues[index];
                return VenueCard(venue: venue);
              },
            ),
          );
        },
      ),
    );
  }
}