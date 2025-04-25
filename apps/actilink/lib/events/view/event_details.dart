import 'dart:developer';

import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/view/widgets/info_card.dart';
import 'package:actilink/events/view/widgets/info_row.dart';
import 'package:core/core.dart'; // Includes models, services
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({required this.event, super.key});
  final Event event;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _currentEvent;
  final NumberFormat _currencyFormat =
      NumberFormat.simpleCurrency(locale: 'en_US');
  User? _organizer;
  String _formattedLocation = 'Loading location...';
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
    _fetchOrganizerDetailsIfNeeded();
    _fetchFormattedLocation();
  }

  @override
  void didUpdateWidget(covariant EventDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.event != oldWidget.event) {
      setState(() {
        _currentEvent = widget.event;
        _organizer = null;
        _formattedLocation = 'Loading location...';
      });
      _fetchOrganizerDetailsIfNeeded();
      _fetchFormattedLocation();
    }
  }

  Future<void> _fetchOrganizerDetailsIfNeeded() async {
    if (_currentEvent.organizerId.isNotEmpty) {
      try {
        final userRepo = RepositoryProvider.of<UserRepository>(context);
        final organizer =
            await userRepo.fetchUserById(_currentEvent.organizerId);
        if (mounted) {
          setState(() {
            _organizer = organizer;
          });
        }
      } catch (e) {
        log('Error fetching organizer details: $e');
      }
    }
  }

  Future<void> _fetchFormattedLocation() async {
    if (_currentEvent.location.latitude == 0 &&
        _currentEvent.location.longitude == 0) {
      if (mounted) {
        setState(() => _formattedLocation = 'Location not specified');
      }
      return;
    }

    try {
      final service = context.read<GoogleMapsService>();
      final address = await service.reverseGeocode(_currentEvent.location);
      if (mounted) {
        setState(() {
          _formattedLocation = address ?? 'Address unavailable';
        });
      }
    } catch (e) {
      log('Error reverse geocoding in EventDetails: $e');
      if (mounted) {
        setState(() {
          _formattedLocation =
              'Lat: ${_currentEvent.location.latitude.toStringAsFixed(4)}, Lon: ${_currentEvent.location.longitude.toStringAsFixed(4)}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select(
      (AuthCubit cubit) => cubit.state is AuthAuthenticated
          ? (cubit.state as AuthAuthenticated).user
          : null,
    );
    final isOrganizer = currentUser?.id == _currentEvent.organizerId;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Row with Back Button, Title, Organizer, Actions ---
              Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => context.go('/events'),
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

                  // Title and Organizer Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentEvent.title ?? 'Event Details',
                          style: AppTextStyles.displayMedium.copyWith(
                            fontSize: 22,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        if (_organizer != null)
                          Text(
                            'Organized by ${_organizer!.name}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        else if (_currentEvent.organizerId.isNotEmpty)
                          Text(
                            'Loading organizer...',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),

                  // Edit/Delete Buttons for Organizer
                  if (isOrganizer)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.brand,
                          ),
                          tooltip: 'Edit Event',
                          onPressed: _navigateToEdit,
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
                          tooltip: 'Delete Event',
                          onPressed: _isDeleting ? null : _confirmDeleteEvent,
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Info Card ---
              InfoCard(
                children: [
                  InfoRow(
                    icon: Icons.schedule_outlined,
                    label: 'Starts',
                    value: _formatDateTime(_currentEvent.startTime),
                  ),
                  InfoRow(
                    icon: Icons.event_available_outlined,
                    label: 'Ends',
                    value: _formatDateTime(_currentEvent.endTime),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                  InfoRow(
                    icon: Icons.place_outlined,
                    label: 'Location',
                    value: _formattedLocation,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                  InfoRow(
                    icon: Icons.attach_money_outlined,
                    label: 'Price',
                    value: _currentEvent.price <= 0
                        ? 'Free'
                        : _currencyFormat.format(_currentEvent.price),
                  ),
                  InfoRow(
                    icon: Icons.people_outline,
                    label: 'Capacity',
                    value: _formatCapacity(
                      _currentEvent.minUsers,
                      _currentEvent.maxUsers,
                    ),
                  ),
                  InfoRow(
                    icon: Icons.groups_outlined,
                    label: 'Attending',
                    value:
                        '${_currentEvent.participants.length} ${_currentEvent.participants.length == 1 ? "person" : "people"}', // Placeholder
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Description Section
              if (_currentEvent.description != null &&
                  _currentEvent.description!.isNotEmpty)
                _buildSection(
                  title: 'About this Event',
                  child: Text(
                    _currentEvent.description!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),

              // Hobbies Section
              if (_currentEvent.hobbies.isNotEmpty)
                _buildSection(
                  title: 'Related Hobbies',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _currentEvent.hobbies
                        .map(
                          (hobby) => Chip(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            label: Text(hobby.name),
                            backgroundColor:
                                AppColors.accent.withValues(alpha: 0.9),
                            labelStyle: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                              fontSize: 13,
                            ), // Adjusted style
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
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

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  // --- Helper Methods ---

  String _formatDateTime(DateTime dateTime) {
    final dt = dateTime.toLocal();
    return DateFormat("MMM dd, yyyy 'at' HH:mm").format(dt);
  }

  String _formatCapacity(int min, int max) {
    if (max <= 0) {
      return '$min or more participants';
    } else if (min == max) {
      return 'Exactly $min participants';
    } else {
      return '$min - $max participants';
    }
  }

  // --- Actions ---
  Future<void> _navigateToEdit() async {
    // Używamy context.push zamiast Navigator.push
    final result = await context.push<Event>(
      '/events/edit/${_currentEvent.id}', // Ścieżka prowadząca do formularza edycji
      extra: _currentEvent, // Przekazujemy event jako extra
    );

    if (result != null && mounted) {
      log('Returned from Edit screen with updated event: ${result.title}');
      setState(() {
        _currentEvent = result;
        _organizer = null;
        _formattedLocation = 'Loading location...';
      });
      await _fetchOrganizerDetailsIfNeeded();
      await _fetchFormattedLocation();

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Event updated successfully'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );
      }
    } else {
      log('Returned from Edit screen, no update or widget unmounted.');
    }
  }

  void _confirmDeleteEvent() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Event?', style: AppTextStyles.labelMedium),
          content: Text(
            'Are you sure you want to permanently delete "${_currentEvent.title ?? 'this event'}"? This action cannot be undone.',
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
                _deleteEvent();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEvent() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);
    log('Deleting event ${_currentEvent.id}');

    var success = false;
    String? errorMsg;
    try {
      success = await context.read<EventsCubit>().deleteEvent(_currentEvent.id);
      if (!success && mounted) {
        errorMsg = context.read<EventsCubit>().state.error.isNotEmpty
            ? context.read<EventsCubit>().state.error
            : 'Failed to delete event.';
      }
    } catch (e) {
      log('Error calling deleteEvent cubit method: $e');
      errorMsg = 'An unexpected error occurred during deletion.';
    }

    if (!mounted) {
      return;
    }

    setState(() => _isDeleting = false);

    if (success) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Event deleted successfully'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(errorMsg ?? 'Failed to delete event.'),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }
}
