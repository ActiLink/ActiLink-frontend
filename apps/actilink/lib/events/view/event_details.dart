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
              _infoCard([
                _infoRow(
                    Icons.schedule, 'Start', _formatDateTime(event.startTime),),
                _infoRow(Icons.event, 'End', _formatDateTime(event.endTime)),
                _infoRow(
                    Icons.place, 'Location', event.location ?? 'No location',),
                if (event.venue != null)
                  _infoRow(Icons.location_city, 'Venue', event.venue!),
                _infoRow(Icons.price_change, 'Price',
                    '\$${event.price.toStringAsFixed(2)}',),
                _infoRow(Icons.people, 'Users',
                    '${event.minUsers} - ${event.maxUsers}',),
              ]),

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

  Widget _infoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brand),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dt = dateTime.toLocal();
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
