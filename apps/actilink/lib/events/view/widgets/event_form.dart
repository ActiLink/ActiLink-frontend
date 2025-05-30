import 'dart:developer';

import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/events_state.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
import 'package:actilink/events/view/widgets/datetime_picker.dart';
import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class EventForm extends StatefulWidget {
  const EventForm({
    required this.onSubmit,
    super.key,
    this.event,
  });

  final Event? event;
  final void Function(Event) onSubmit;

  @override
  State<EventForm> createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _minUsersController;
  late TextEditingController _maxUsersController;
  late TextEditingController _hobbySearchController;
  late DateTime _startTime;
  late DateTime _endTime;
  Location? _selectedLocation;
  final List<Hobby> _selectedHobbies = [];
  List<Hobby> _filteredHobbies = [];
  bool _isSearching = false;
  bool _isSubmitting = false;
  bool _isFetchingInitialLocation = false;

  Venue? _selectedVenue;
  List<Venue> _venues = [];
  Future<void> _loadVenues() async {
    final venues = context.read<VenuesCubit>().state.venues;
    setState(() => _venues = venues);
  }

  @override
  void initState() {
    super.initState();

    _loadVenues();

    if (widget.event != null) {
      _selectedVenue = widget.event!.venue;
    }

    _titleController = TextEditingController(text: widget.event?.title);
    _descriptionController =
        TextEditingController(text: widget.event?.description);
    _locationController = TextEditingController();
    _priceController =
        TextEditingController(text: widget.event?.price.toString());
    _minUsersController =
        TextEditingController(text: widget.event?.minUsers.toString());
    _maxUsersController =
        TextEditingController(text: widget.event?.maxUsers.toString());
    _hobbySearchController = TextEditingController();
    _startTime = widget.event?.startTime ?? DateTime.now();
    _endTime =
        widget.event?.endTime ?? DateTime.now().add(const Duration(hours: 1));

    _selectedHobbies.clear();
    if (widget.event?.hobbies != null) {
      _selectedHobbies.addAll(widget.event!.hobbies);
    }

    _hobbySearchController.addListener(_filterHobbies);

    if (widget.event != null) {
      _selectedLocation = widget.event!.location;
      _fetchInitialAddress();
    }
  }

  Future<void> _fetchInitialAddress() async {
    if (_selectedLocation != null &&
        _selectedLocation!.latitude != 0 &&
        _selectedLocation!.longitude != 0) {
      setState(() => _isFetchingInitialLocation = true);
      try {
        final address = await context
            .read<GoogleMapsService>()
            .reverseGeocode(_selectedLocation!);
        if (mounted && address != null) {
          _locationController.text = address;
        } else if (mounted) {
          _locationController.text =
              'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lon: ${_selectedLocation!.longitude.toStringAsFixed(4)}';
        }
      } catch (e) {
        log('Error fetching initial address: $e');
        if (mounted) _locationController.text = 'Could not fetch address';
      } finally {
        if (mounted) setState(() => _isFetchingInitialLocation = false);
      }
    } else {
      _locationController.text = '';
    }
  }

  void _filterHobbies() {
    final query = _hobbySearchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHobbies = [];
        _isSearching = false;
      } else {
        _isSearching = true;
        final allHobbies = context.read<HobbiesCubit>().state.hobbies;
        _filteredHobbies = allHobbies
            .where(
              (hobby) =>
                  hobby.name.toLowerCase().contains(query) &&
                  !_selectedHobbies.contains(hobby),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _minUsersController.dispose();
    _maxUsersController.dispose();
    _hobbySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsCubit, EventsState>(
      listener: (context, state) {
        if (_isSubmitting) {
          if (state.status == EventsStatus.failure) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: AppColors.error,
                ),
              );
          }
        }
      },
      child: Scaffold(
        appBar: widget.event == null
            ? null
            : AppBar(
                title: const Text('Edit Event'),
              ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Title and Description Fields ---
                AppTextField(
                  label: 'Title',
                  hintText: 'Enter event title',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                AppTextField(
                  label: 'Description',
                  hintText: 'Enter event description',
                  controller: _descriptionController,
                  multiline: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // --- Location Field ---
                if (_selectedVenue == null)
                  AppTextField(
                    label: 'Location Address',
                    hintText: 'Enter event address',
                    controller: _locationController,
                    suffixIcon: _isFetchingInitialLocation
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Location address is required';
                      }
                      return null;
                    },
                  ),

                if (_venues.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DropdownButtonFormField<Venue?>(
                      value: _selectedVenue,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Venue (optional)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<Venue?>(
                          child: Text('No venue'),
                        ),
                        ..._venues.map(
                          (venue) => DropdownMenuItem<Venue?>(
                            value: venue,
                            child: Text(venue.name),
                          ),
                        ),
                      ],
                      onChanged: (venue) {
                        setState(() {
                          _selectedVenue = venue;
                          if (venue != null) {
                            _selectedLocation = venue.location;
                            _locationController.text =
                                'Lat: ${venue.location.latitude.toStringAsFixed(4)}, Lon: ${venue.location.longitude.toStringAsFixed(4)}';
                          } else {
                            _locationController.text = '';
                          }
                        });
                      },
                    ),
                  ),

                const SizedBox(height: 8),

                // --- Price and User Capacity Fields ---
                AppTextField(
                  label: 'Price',
                  hintText: 'Enter event price (0 for free)',
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) < 0) {
                      return 'Enter a valid non-negative price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Min Participants',
                        hintText: 'Min',
                        controller: _minUsersController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final minUsers = int.tryParse(value);
                          if (minUsers == null || minUsers <= 0) {
                            // Should be at least 1
                            return 'Invalid (>0)';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        label: 'Max Participants',
                        hintText: 'Max',
                        controller: _maxUsersController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final maxUsers = int.tryParse(value);
                          if (maxUsers == null || maxUsers < 0) {
                            return 'Invalid (>=0)';
                          }
                          final minUsers =
                              int.tryParse(_minUsersController.text);
                          if (minUsers != null &&
                              maxUsers > 0 &&
                              maxUsers < minUsers) {
                            return 'Max < Min';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DateTimePicker(
                        label: 'Start Time',
                        initialDate: _startTime,
                        onDateChanged: (startTime) {
                          setState(() {
                            _startTime = startTime;
                            if (_endTime.isBefore(_startTime)) {
                              _endTime =
                                  _startTime.add(const Duration(hours: 1));
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DateTimePicker(
                        label: 'End Time',
                        initialDate: _endTime,
                        onDateChanged: (endTime) {
                          if (endTime.isBefore(_startTime)) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'End time cannot be before start time.',
                                  ),
                                  backgroundColor: AppColors.warning,
                                ),
                              );
                          } else {
                            setState(() {
                              _endTime = endTime;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // --- Hobby Selection Widget ---
                Text(
                  'Related Hobbies',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  label: 'Search Hobbies',
                  hintText: 'Type to search hobbies',
                  controller: _hobbySearchController,
                  suffixIcon: _hobbySearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _hobbySearchController.clear();
                          },
                        )
                      : null,
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (_isSearching && _filteredHobbies.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: _filteredHobbies.map((hobby) {
                              return ActionChip(
                                label: Text(hobby.name),
                                onPressed: () {
                                  setState(() {
                                    _selectedHobbies.add(hobby);
                                    _filterHobbies();
                                  });
                                },
                                backgroundColor: AppColors.surface,
                                side: const BorderSide(color: AppColors.border),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                labelStyle: AppTextStyles.labelMedium
                                    .copyWith(color: AppColors.textPrimary),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                avatar: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: AppColors.brand,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (_selectedHobbies.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: _selectedHobbies.map((hobby) {
                              return Chip(
                                label: Text(hobby.name),
                                onDeleted: () {
                                  setState(() {
                                    _selectedHobbies.removeWhere(
                                      (h) => h == hobby,
                                    );
                                    _filterHobbies();
                                  });
                                },
                                backgroundColor: AppColors.accent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                labelStyle: AppTextStyles.labelMedium
                                    .copyWith(color: AppColors.highlight),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                deleteIconColor: AppColors.highlight,
                              );
                            }).toList(),
                          ),
                        ),
                      if (_isSearching &&
                          _filteredHobbies.isEmpty &&
                          _hobbySearchController.text.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'No matching hobbies found.',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Submit Button ---
                Center(
                  child: AppButton(
                    onPressed: _isSubmitting ? () {} : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.black,
                            ),
                          )
                        : Text(
                            widget.event == null
                                ? 'Post Event'
                                : 'Save Changes',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      // Time validation
      if (_endTime.isBefore(_startTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time.'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      // User capacity validation
      final minUsers = int.parse(_minUsersController.text);
      final maxUsers = int.parse(_maxUsersController.text);
      if (maxUsers > 0 && maxUsers < minUsers) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum participants cannot be less than minimum.'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      // Authentication check
      final currentUser = context.read<AuthCubit>().user;
      if (currentUser == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication error. Please log in again.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() => _isSubmitting = true);
      // --- Geocode Address ---
      Location? eventLocation;
      if (_selectedVenue == null) {
        try {
          if (mounted) {
            eventLocation = await context
                .read<GoogleMapsService>()
                .forwardGeocode(_locationController.text.trim());
          }

          if (eventLocation == null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Could not find coordinates for the provided address. Please check the address.',
                ),
                backgroundColor: AppColors.error,
              ),
            );
            setState(() => _isSubmitting = false);
            return;
          }
        } catch (e) {
          log('Error during forward geocoding: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('An error occurred while verifying the location.'),
                backgroundColor: AppColors.error,
              ),
            );
            setState(() => _isSubmitting = false);
          }
          return;
        }
      } else {
        eventLocation = _selectedVenue!.location;
      }
      // --- Create Event Data ---
      final eventData = Event(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: eventLocation!,
        venue: _selectedVenue,
        price: double.parse(_priceController.text),
        minUsers: minUsers,
        maxUsers: maxUsers,
        startTime: _startTime,
        endTime: _endTime,
        hobbies: _selectedHobbies,
      );

      var success = false;
      Event? resultEvent;

      try {
        if (widget.event == null && mounted) {
          log('Attempting to add event...');
          success = await context.read<EventsCubit>().addEvent(eventData);
          if (success) {
            resultEvent = eventData;
          }
          if (!mounted) return;
          // Update Venue to include this event
          if (_selectedVenue != null && resultEvent?.id != null) {
            context
                .read<VenuesCubit>()
                .addEventToVenue(_selectedVenue!.id, resultEvent!);
            log('Venue ${_selectedVenue!.name} locally updated with new event ${resultEvent.id}');
          }
        } else if (mounted) {
          log('Attempting to update event ${widget.event!.id}...');
          resultEvent = await context
              .read<EventsCubit>()
              .updateEvent(widget.event!.id!, eventData);
          success = resultEvent != null;
        }

        if (success && mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Event ${widget.event == null ? 'posted' : 'updated'} successfully!',
                ),
                backgroundColor: AppColors.success,
              ),
            );

          widget.onSubmit(resultEvent ?? eventData);
        } else if (!success && mounted) {
          if (context.read<EventsCubit>().state.error.isEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to ${widget.event == null ? 'post' : 'update'} event. Please try again.',
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Error: ${context.read<EventsCubit>().state.error}',
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
          }
        }
      } catch (e) {
        log('Error submitting form: $e');
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('An unexpected error occurred: $e'),
                backgroundColor: AppColors.error,
              ),
            );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    } else {
      log('Form validation failed.');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please fix the errors in the form.'),
            backgroundColor: AppColors.warning,
          ),
        );
    }
  }
}
