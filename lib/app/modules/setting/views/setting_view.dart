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
        title: Text(
          'settings'.tr,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance
          _sectionTitle(context, 'appearance'.tr),
          Card(
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    title: Text(
                      'dark_mode'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'enable_dark_theme'.tr,
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
          _sectionTitle(context, 'language'.tr),
          Card(
            child: Obx(() {
              final isEn = controller.currentLanguage.value == 'English';
              final isMm = controller.currentLanguage.value == 'Myanmar';

              final theme = Theme.of(context);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.language, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'language'.tr,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),

                    // 🇺🇸 English
                    ChoiceChip(
                      label: const Text('🇺🇸 EN'),
                      selected: isEn,
                      showCheckmark: false,
                      selectedColor: theme.colorScheme.secondary,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: isEn ? FontWeight.bold : FontWeight.normal,
                        color: isEn
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (_) => controller.setLanguage('en'),
                    ),

                    const SizedBox(width: 8),

                    // 🇲🇲 Myanmar
                    ChoiceChip(
                      label: const Text('🇲🇲 MM'),
                      selected: isMm,
                      showCheckmark: false,
                      selectedColor: theme.colorScheme.secondary,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: isMm ? FontWeight.bold : FontWeight.normal,
                        color: isMm
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (_) => controller.setLanguage('my'),
                    ),
                  ],
                ),
              );
            }),
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
          _sectionTitle(context, 'about_section'.tr),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('about_app'.tr),
                  onTap: controller.openAbout,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text('privacy_policy'.tr),
                  onTap: controller.openPrivacyPolicy,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text('terms_conditions'.tr),
                  onTap: controller.openTerms,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.system_update),
                  title: Text('app_version'.tr),
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
                  'copyright'.tr,
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
