import 'dart:developer';
import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/view/widgets/info_card.dart';
import 'package:actilink/events/view/widgets/info_row.dart';
import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

class VenueDetailsScreen extends StatefulWidget {
  const VenueDetailsScreen({required this.venue, super.key});
  final Venue venue;

  @override
  State<VenueDetailsScreen> createState() => _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends State<VenueDetailsScreen> {
  late Venue _currentVenue;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _currentVenue = widget.venue;
    _fetchFormattedLocation();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().user;
    final isOwner = currentUser?.id == _currentVenue.owner?.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/venues'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.border.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentVenue.name,
                          style: AppTextStyles.displayMedium.copyWith(
                            fontSize: 22,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        if (_currentVenue.owner != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Owned by ${_currentVenue.owner!.name}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isOwner)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.brand,
                          ),
                          tooltip: 'Edit Venue',
                          onPressed: () async {
                            final result = await context.push<Venue>(
                              '/venues/edit/${_currentVenue.id}',
                              extra: _currentVenue,
                            );
                            if (result != null && mounted) {
                              setState(() => _currentVenue = result);
                            }
                          },
                        ),
                        IconButton(
                          icon: _isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.error,
                                  ),
                                )
                              : Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error.withValues(alpha: 0.9),
                                ),
                          tooltip: 'Delete Venue',
                          onPressed: _isDeleting ? null : _confirmDeleteVenue,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 24),
              InfoCard(
                children: [
                  InfoRow(
                    icon: Icons.place_outlined,
                    label: 'Address',
                    value: _currentVenue.address,
                  ),
                  if (_currentVenue.events.isNotEmpty) ...[
                    const Divider(
                      height: 20,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                    InfoRow(
                      icon: Icons.event_outlined,
                      label: 'Events',
                      value: '${_currentVenue.events.length} upcoming',
                    ),
                  ],
                ],
              ),
              if (_currentVenue.description.isNotEmpty)
                _buildSection(
                  title: 'About this Venue',
                  child: Text(
                    _currentVenue.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              if (_currentVenue.events.isNotEmpty)
                _buildSection(
                  title: 'Upcoming Events',
                  child: Column(
                    children: _currentVenue.events
                        .map(
                          (event) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: AppColors.surface, // Add white background
                            child: ListTile(
                              title: Text(
                                event.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                event.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              onTap: () async {
                                final eventId = event.id;
                                await _navigateToEventDetails(eventId!);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToEventDetails(String eventId) async {
    final fullEvent = await context.read<EventsCubit>().fetchEventById(eventId);

    if (!mounted) return;

    if (fullEvent != null) {
      context.go('/events/details/${fullEvent.id}', extra: fullEvent);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load event details.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Future<void> _fetchFormattedLocation() async {
    try {
      context.read<GoogleMapsService>();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log('Error reverse geocoding in VenueDetails: $e');
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _confirmDeleteVenue() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Venue?', style: AppTextStyles.labelMedium),
          content: Text(
            'Are you sure you want to permanently delete "${_currentVenue.name}"? This action cannot be undone.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteVenue();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVenue() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);
    log('Deleting venue ${_currentVenue.id}');

    var success = false;
    String? errorMsg;

    try {
      success = await context.read<VenuesCubit>().deleteVenue(_currentVenue.id);
      if (!success && mounted) {
        errorMsg = context.read<VenuesCubit>().state.error.isNotEmpty
            ? context.read<VenuesCubit>().state.error
            : 'Failed to delete venue.';
      }
    } catch (e) {
      log('Error deleting venue: $e');
      errorMsg = 'An unexpected error occurred while deleting the venue.';
    }

    if (!mounted) return;

    setState(() => _isDeleting = false);

    if (success) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Venue deleted successfully'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

      context.go('/venues');
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(errorMsg ?? 'Failed to delete venue'),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }
}
