import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.accent,
              child: Icon(Icons.person, size: 50, color: AppColors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Username',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a short bio about the user.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Edit Profile',
                style:
                    AppTextStyles.labelMedium.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 40),
            Divider(
              thickness: 1,
              color: AppColors.accent.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'My Events',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: AppColors.white,
                    child: ListTile(
                      leading: const Icon(Icons.event, color: AppColors.brand),
                      title: Text(
                        'Event ${index + 1}',
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: const Text(
                        'Event details here',
                        style: AppTextStyles.bodySmall,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthCubit>().logout(
                      context,
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand.withValues(alpha: 0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Logout',
                style:
                    AppTextStyles.labelMedium.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
