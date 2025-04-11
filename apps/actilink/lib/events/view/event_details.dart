import 'package:actilink/events/view/widgets/info_card.dart';
import 'package:actilink/events/view/widgets/info_row.dart';
import 'package:actilink/models/event.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title ?? 'Event Details',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'with ${event.user ?? 'someone'}',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Info Card
              InfoCard(
                children: [
                  InfoRow(
                    icon: Icons.schedule,
                    label: 'Start',
                    value: _formatDateTime(event.startTime),
                  ),
                  InfoRow(
                    icon: Icons.event,
                    label: 'End',
                    value: _formatDateTime(event.endTime),
                  ),
                  InfoRow(
                    icon: Icons.place,
                    label: 'Location',
                    value: event.location ?? 'No location',
                  ),
                  if (event.venue != null)
                    InfoRow(
                      icon: Icons.location_city,
                      label: 'Venue',
                      value: event.venue!,
                    ),
                  InfoRow(
                    icon: Icons.price_change,
                    label: 'Price',
                    value: '\$${event.price.toStringAsFixed(2)}',
                  ),
                  InfoRow(
                    icon: Icons.people,
                    label: 'Users',
                    value: '${event.minUsers} - ${event.maxUsers}',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Description
              if (event.description != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: AppTextStyles.displayMedium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description!,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

              // Hobbies
              if (event.relatedHobbies.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join if you enjoy',
                      style: AppTextStyles.displayMedium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: event.relatedHobbies
                          .map(
                            (hobby) => Chip(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              label: Text(hobby),
                              backgroundColor: AppColors.accent,
                              labelStyle: AppTextStyles.labelMedium
                                  .copyWith(color: AppColors.highlight),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dt = dateTime.toLocal();
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
