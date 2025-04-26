import 'dart:developer';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, super.key});
  final Event event;

  Future<String> _getFormattedLocation(
    BuildContext context,
    Location loc,
  ) async {
    if (loc.latitude == 0 && loc.longitude == 0) {
      return 'Location not specified';
    }
    try {
      final service = context.read<GoogleMapsService>();
      final address = await service.reverseGeocode(loc);
      return address ?? 'Address unavailable';
    } catch (e) {
      log('Error reverse geocoding in EventCard: $e');
      return 'Lat: ${loc.latitude.toStringAsFixed(2)}, Lon: ${loc.longitude.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedStartTime =
        DateFormat('HH:mm').format(event.startTime.toLocal());
    final formattedStartDate =
        DateFormat('MMM dd').format(event.startTime.toLocal());

    return Card(
      color: AppColors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.go('/events/details/${event.id}', extra: event);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                event.title ?? 'Untitled Event',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Organizer name
              FutureBuilder<User?>(
                future: context
                    .read<UserRepository>()
                    .fetchUserById(event.organizerId),
                builder: (context, snapshot) {
                  final username = snapshot.data?.name ?? '...';
                  return Text(
                    'Organized by $username',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),

              const SizedBox(height: 12),

              // Info rows: Location and Time/Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 18,
                    color: AppColors.brand,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _getFormattedLocation(context, event.location),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading location...',
                            style: AppTextStyles.bodySmall,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading location',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.error),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? 'Location not specified',
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.brand,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$formattedStartDate, $formattedStartTime',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Hobby chips
              if (event.hobbies.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: event.hobbies
                      .take(3)
                      .map(
                        (hobby) => Chip(
                          visualDensity: VisualDensity.compact,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          label: Text(hobby.name),
                          backgroundColor:
                              AppColors.accent.withValues(alpha: 0.8),
                          labelStyle: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.white, fontSize: 11),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                        ),
                      )
                      .toList(),
                ),
              if (event.hobbies.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${event.hobbies.length - 3} more',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
