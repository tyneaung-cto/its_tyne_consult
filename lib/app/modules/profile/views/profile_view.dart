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
        title: Text(
          'profile_title'.tr,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile header
              _ProfileHeader(
                name: controller.userName.value,
                email: controller.userEmail.value,
              ),

              AppSpacing.h24,

              // Account info
              _sectionTitle('account_information'.tr, context),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text('full_name'.tr),
                      subtitle: Text(
                        controller.userName.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: controller.editUserNameDialog,
                      ),
                    ),
                    const Divider(height: 1),
                    _infoTile(
                      icon: Icons.email_outlined,
                      title: 'email'.tr,
                      value: controller.userEmail.value.toString(),
                      context: context,
                    ),
                    const Divider(height: 1),
                    _infoTile(
                      icon: Icons.badge_outlined,
                      title: 'role'.tr,
                      value: controller.userRole.value.toString(),
                      context: context,
                    ),
                  ],
                ),
              ),

              AppSpacing.h16,

              // Actions
              _sectionTitle('actions'.tr, context),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: Text('change_password'.tr),
                      onTap: controller.changePassword,
                    ),
                  ],
                ),
              ),

              AppSpacing.h24,

              // Footer
              Text(
                'profile_secure_note'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(38),
          child: Text(
            name.trim().isNotEmpty
                ? name.trim()[0].toUpperCase()
                : (email.isNotEmpty ? email[0].toUpperCase() : '?'),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
