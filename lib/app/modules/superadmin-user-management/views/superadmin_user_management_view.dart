import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/superadmin_user_management_controller.dart';

class SuperadminUserManagementView
    extends GetView<SuperadminUserManagementController> {
  const SuperadminUserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredUsers.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _FilterChip(label: 'All', value: 'all'),
                  _FilterChip(label: 'Active', value: 'active'),
                  _FilterChip(label: 'Banned', value: 'banned'),
                  _FilterChip(label: 'Clients', value: 'client'),
                  _FilterChip(label: 'Consultants', value: 'consultant'),
                  _FilterChip(label: 'Admins', value: 'admin'),
                  _FilterChip(label: 'Super Admins', value: 'superadmin'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredUsers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User info
                          Row(
                            children: [
                              CircleAvatar(
                                child: Text(
                                  user.username.isNotEmpty
                                      ? user.username[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.username,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      user.email,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              _StatusChip(
                                label: user.isBanned ? 'BANNED' : 'ACTIVE',
                                color: user.isBanned
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Role
                          Row(
                            children: [
                              const Text('Role:'),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: user.role,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'client',
                                    child: Text('Client'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'consultant',
                                    child: Text('Consultant'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'admin',
                                    child: Text('Admin'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'superadmin',
                                    child: Text('Super Admin'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null && value != user.role) {
                                    controller.changeUserRole(
                                      userId: user.uid,
                                      newRole: value,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Delete button (clients only)
                              if (user.role == 'client')
                                TextButton(
                                  onPressed: () {
                                    controller.deleteUser(userId: user.uid);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),

                              if (user.role == 'client')
                                const SizedBox(width: 8),

                              // Ban / Unban
                              TextButton(
                                onPressed: () {
                                  controller.toggleBanUser(
                                    userId: user.uid,
                                    isBanned: !user.isBanned,
                                  );
                                },
                                child: Text(user.isBanned ? 'Unban' : 'Ban'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;

  const _FilterChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SuperadminUserManagementController>();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.activeFilter.value == value;
        return ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => controller.setFilter(value),
        );
      }),
    );
  }
}
