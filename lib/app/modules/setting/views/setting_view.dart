import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance
          _sectionTitle(context, 'Appearance'),
          Card(
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    title: Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'Enable dark theme',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: controller.isDarkMode.value,
                    onChanged: controller.toggleTheme,
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.h16,

          // Language
          _sectionTitle(context, 'Language'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Language'),
                  subtitle: Obx(
                    () => Text(
                      controller.currentLanguage.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.changeLanguage,
                ),
              ],
            ),
          ),

          AppSpacing.h16,

          // // Account
          // _sectionTitle(context, 'Account'),
          // Card(
          //   child: Column(
          //     children: [
          //       ListTile(
          //         leading: const Icon(Icons.person_outline),
          //         title: const Text('Profile'),
          //         onTap: controller.goToProfile,
          //       ),
          //       const Divider(height: 1),
          //       ListTile(
          //         leading: const Icon(Icons.logout),
          //         title: const Text('Logout'),
          //         onTap: controller.logout,
          //       ),
          //     ],
          //   ),
          // ),

          // AppSpacing.h16,

          // About
          _sectionTitle(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About ItsTyne Consult'),
                  onTap: controller.openAbout,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  onTap: controller.openPrivacyPolicy,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms & Conditions'),
                  onTap: controller.openTerms,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.system_update),
                  title: const Text('App Version'),
                  subtitle: Text(
                    AppConstants.appVersion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.h24,

          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  'ItsTyne Consult',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2026 TECH4MM. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
