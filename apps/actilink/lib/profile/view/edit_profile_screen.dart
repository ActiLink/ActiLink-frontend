import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
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

  final List<Hobby> _selectedHobbies = [];
  List<Hobby> _filteredHobbies = [];
  late TextEditingController _hobbySearchController;
  bool _isSearching = false;

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
    _hobbySearchController = TextEditingController();
    final user = context.read<AuthCubit>().user;
    if (user is User && user.hobbies != null) {
      _selectedHobbies.addAll(user.hobbies!);
    }
    _hobbySearchController.addListener(_filterHobbies);
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
          hobbies: _selectedHobbies,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
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

              // Hobbies section
              if (!_isBusinessClient) ...[
                const SizedBox(height: 24),
                const _SectionHeader(title: 'Hobbies'),
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
                        Text(
                          'Your Hobbies',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
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
                                        (h) => h.name == hobby.name,
                                      );
                                      _filterHobbies();
                                    });
                                  },
                                  backgroundColor: AppColors.accent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
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
                        const SizedBox(height: 16),
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
                                  side:
                                      const BorderSide(color: AppColors.border),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
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
                ),
              ],

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
              const SizedBox(height: 24),
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
