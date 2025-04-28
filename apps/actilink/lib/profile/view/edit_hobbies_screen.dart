import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class EditHobbiesScreen extends StatelessWidget {
  const EditHobbiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Placeholder screen
      appBar: AppBar(title: const Text('Select Hobbies')),
      body: const Center(
        child: Text(
          'Hobby selection coming soon!',
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}
