import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _taxIdController;

  bool _isSaving = false;
  bool _isBusinessClient = false;
  BaseUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = context.read<AuthCubit>().user;

    if (_currentUser == null) {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _taxIdController = TextEditingController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar('User data not found. Please log in again.');
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    } else {
      _nameController = TextEditingController(text: _currentUser!.name);
      _emailController = TextEditingController(text: _currentUser!.email);
      _isBusinessClient = _currentUser is BusinessClient;
      _taxIdController = TextEditingController(
        text: _isBusinessClient ? (_currentUser! as BusinessClient).taxId : '',
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.success),
      );
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.user;

    if (currentUser == null) {
      _showErrorSnackBar('Authentication error. Please log in again.');
      setState(() => _isSaving = false);
      return;
    }

    try {
      BaseUser updatedUser;
      final newName = _nameController.text.trim();
      final newEmail = _emailController.text.trim();

      if (currentUser is BusinessClient) {
        final newTaxId = _taxIdController.text.trim();
        updatedUser = currentUser.copyWith(
          name: newName,
          email: newEmail,
          taxId: newTaxId,
        );
      } else if (currentUser is User) {
        updatedUser = currentUser.copyWith(
          name: newName,
          email: newEmail,
        );
      } else {
        throw Exception('Unknown user type');
      }

      await authCubit.updateUserProfile(updatedUser);

      _showSuccessSnackBar('Profile updated successfully!');
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _navigateToSetHobbies() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Hobby selection screen coming soon!'),
          backgroundColor: AppColors.info,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.interests_outlined, color: AppColors.brand),
            tooltip: 'Set Hobbies',
            onPressed: _navigateToSetHobbies,
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Personal information section
              const _SectionHeader(title: 'Personal Information'),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'Name',
                        hintText: 'Enter your name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty.';
                          }
                          if (value.trim().length < 3) {
                            return 'Name must be at least 3 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Email',
                        hintText: 'Enter your email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email cannot be empty.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value.trim())) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Business information section
              if (_isBusinessClient) ...[
                const SizedBox(height: 24),
                const _SectionHeader(title: 'Business Information'),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  color: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppTextField(
                      label: 'Tax ID',
                      hintText: 'Enter your business Tax ID',
                      controller: _taxIdController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tax ID is required for business accounts.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Save button
              Center(
                child: AppButton(
                  onPressed: _isSaving ? () {} : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.black,
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
