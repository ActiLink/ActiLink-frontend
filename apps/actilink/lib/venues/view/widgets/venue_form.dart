import 'package:core/core.dart';
import 'package:flutter/material.dart';
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

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue?.name);
    _descriptionController = TextEditingController(text: widget.venue?.description);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Venue' : 'Add Venue'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter venue name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter venue description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter venue address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
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
                        color: Colors.white,
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
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final venue = widget.venue?.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
      ) ?? Venue(
        id: '',
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        location: const Location(latitude: 0, longitude: 0),
      );

      await widget.onSubmit(venue);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
