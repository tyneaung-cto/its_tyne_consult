import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            _ProfileHeader(
              name: controller.userName,
              email: controller.userEmail,
            ),

            AppSpacing.h24,

            // Account info
            _sectionTitle('Account Information', context),
            Card(
              child: Column(
                children: [
                  _infoTile(
                    icon: Icons.person_outline,
                    title: 'Full Name',
                    value: controller.userName,
                    context: context,
                  ),
                  const Divider(height: 1),
                  _infoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: controller.userEmail,
                    context: context,
                  ),
                  const Divider(height: 1),
                  _infoTile(
                    icon: Icons.badge_outlined,
                    title: 'Role',
                    value: controller.userRole,
                    context: context,
                  ),
                ],
              ),
            ),

            AppSpacing.h16,

            // Actions
            _sectionTitle('Actions', context),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Edit Profile'),
                    onTap: controller.editProfile,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change Password'),
                    onTap: controller.changePassword,
                  ),
                ],
              ),
            ),

            AppSpacing.h24,

            // Footer
            Text(
              'Profile information is managed securely.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 32),
          ),
        ),
        AppSpacing.h12,
        Text(name, style: Theme.of(context).textTheme.titleMedium),
        AppSpacing.h4,
        Text(
          email,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
