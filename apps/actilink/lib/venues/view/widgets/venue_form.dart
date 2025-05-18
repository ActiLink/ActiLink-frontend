import 'dart:developer';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class VenueForm extends StatefulWidget {
  const VenueForm({
    required this.onSubmit,
    this.venue,
    super.key,
  });

  final Venue? venue;
  final Future<void> Function(Venue) onSubmit;

  @override
  State<VenueForm> createState() => _VenueFormState();
}

class _VenueFormState extends State<VenueForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final bool _isFetchingLocation = false;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue?.name);
    _descriptionController =
        TextEditingController(text: widget.venue?.description);
    _addressController = TextEditingController(text: widget.venue?.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.venue != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: 'Name',
              hintText: 'Enter venue name',
              controller: _nameController,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: 'Description',
              hintText: 'Enter venue description',
              controller: _descriptionController,
              multiline: true,
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: 'Address',
              hintText: 'Enter venue address',
              controller: _addressController,
              suffixIcon: _isFetchingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Address is required' : null,
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: _isSubmitting ? () {} : _submitForm,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.black,
                      ),
                    )
                  : Text(isEditing ? 'Update Venue' : 'Create Venue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final rawAddress = _addressController.text.trim();
      final mapsService = context.read<GoogleMapsService>();
      final geocodedLocation = await mapsService.forwardGeocode(rawAddress);

      if (geocodedLocation == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Could not determine coordinates for the given address.'),
            backgroundColor: AppColors.error,
          ),
        );

        setState(() => _isSubmitting = false);
        return;
      }

      final formattedAddress =
          await mapsService.reverseGeocode(geocodedLocation);

      final venue = widget.venue?.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            address: formattedAddress ?? rawAddress,
            location: geocodedLocation,
          ) ??
          Venue(
            id: '',
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            address: formattedAddress ?? rawAddress,
            location: geocodedLocation,
          );

      await widget.onSubmit(venue);
    } catch (e) {
      log('Error during venue submission: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
