import 'package:actilink/events/view/event_details.dart';
import 'package:actilink/models/event.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (context) => EventDetailsScreen(event: event),
            ),
          );
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
                ),
              ),

              const SizedBox(height: 8),

              // Organizer name
              Text(
                'with ${event.user ?? 'someone'}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.black),
              ),

              const SizedBox(height: 12),

              // Info rows
              Row(
                children: [
                  const Icon(Icons.place, size: 16, color: AppColors.brand),
                  const SizedBox(width: 6),
                  Text(
                    event.location ?? 'No location',
                    style: AppTextStyles.bodySmall,
                  ),
                  const Spacer(),
                  const Icon(Icons.schedule, size: 16, color: AppColors.brand),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(event.startTime),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Hobby chips
              if (event.relatedHobbies.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: event.relatedHobbies
                      .map(
                        (hobby) => Chip(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          label: Text(hobby),
                          backgroundColor: AppColors.accent,
                          labelStyle: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.highlight),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final time = dateTime.toLocal();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
