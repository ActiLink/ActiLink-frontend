import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    required this.venue,
    super.key,
  });

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/venues/details/${venue.id}', extra: venue),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venue.name,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                venue.description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                venue.address,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
              if (venue.owner != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Owner: ${venue.owner!.name}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}