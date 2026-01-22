import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/values/app_spacing.dart';
import 'package:its_tyne_consult/app/data/models/consultation_model.dart';
import 'package:its_tyne_consult/app/shared/widgets/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../controllers/superadmin_home_controller.dart';

class SuperadminHomeView extends GetView<SuperadminHomeController> {
  const SuperadminHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ItsTyneConsult: Super Admin'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await controller.logout();
            },
          ),
        ],
      ),
      drawer: MyDrawer(isUser: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Consultations Section (Today & Tomorrow)
            Text(
              'Upcoming Consultations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 260,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index.isEven ? 'Today' : 'Tomorrow',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Consultation Topic #${index + 1}',
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Client: user${index + 1}@email.com',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '10:00 AM • 30 mins',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AppSpacing.h24,

            // Consultation Requests Section
            Text(
              'Consultation Requests',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  children: [
                    _FilterChip(
                      label: 'Pending',
                      selected: controller.selectedStatus.value == 'pending',
                      onTap: () => controller.setStatusFilter('pending'),
                    ),
                    _FilterChip(
                      label: 'Confirmed',
                      selected: controller.selectedStatus.value == 'confirmed',
                      onTap: () => controller.setStatusFilter('confirmed'),
                    ),
                    _FilterChip(
                      label: 'Cancelled',
                      selected: controller.selectedStatus.value == 'cancelled',
                      onTap: () => controller.setStatusFilter('cancelled'),
                    ),
                    _FilterChip(
                      label: 'Rejected',
                      selected: controller.selectedStatus.value == 'rejected',
                      onTap: () => controller.setStatusFilter('rejected'),
                    ),
                    _FilterChip(
                      label: 'All',
                      selected: controller.selectedStatus.value == 'all',
                      onTap: () => controller.setStatusFilter('all'),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.h16,

            Expanded(
              child: Obx(
                () => StreamBuilder<List<Consultation>>(
                  stream: controller.consultationsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final consultations = snapshot.data ?? <Consultation>[];

                    if (consultations.isEmpty) {
                      return const Center(
                        child: Text('No consultation requests'),
                      );
                    }

                    return ListView.separated(
                      itemCount: consultations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final c = consultations[index];
                        final dateFmt = DateFormat('dd MMM yyyy • hh:mm a');

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(c.userId)
                              .get(),
                          builder: (context, userSnap) {
                            final userData =
                                userSnap.data?.data()
                                    as Map<String, dynamic>? ??
                                {};

                            final userName = userData['userName'] ?? 'Unknown';
                            final email = userData['email'] ?? '-';

                            return FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('consultations')
                                  .where('userID', isEqualTo: c.userId)
                                  .get(),
                              builder: (context, statsSnap) {
                                int total = 0,
                                    confirmed = 0,
                                    cancelled = 0,
                                    rejected = 0;

                                if (statsSnap.hasData) {
                                  final docs = statsSnap.data!.docs;
                                  total = docs.length;
                                  for (final d in docs) {
                                    final s = (d['status'] ?? '') as String;
                                    if (s == 'confirmed') confirmed++;
                                    if (s == 'cancelled') cancelled++;
                                    if (s == 'rejected') rejected++;
                                  }
                                }

                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.topic,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '$userName • $email',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Requested: ${c.duration} mins • ${dateFmt.format(c.preferredDate)}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            _StatChip(
                                              label: 'Total',
                                              value: total,
                                            ),
                                            _StatChip(
                                              label: 'Confirmed',
                                              value: confirmed,
                                            ),
                                            _StatChip(
                                              label: 'Cancelled',
                                              value: cancelled,
                                            ),
                                            _StatChip(
                                              label: 'Rejected',
                                              value: rejected,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => controller
                                                  .updateConsultationStatus(
                                                    consultationId: c.id,
                                                    userId: c.userId,
                                                    status: 'rejected',
                                                  ),
                                              child: const Text('Reject'),
                                            ),
                                            TextButton(
                                              onPressed: () => controller
                                                  .updateConsultationStatus(
                                                    consultationId: c.id,
                                                    userId: c.userId,
                                                    status: 'cancelled',
                                                  ),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => controller
                                                  .updateConsultationStatus(
                                                    consultationId: c.id,
                                                    userId: c.userId,
                                                    status: 'confirmed',
                                                  ),
                                              child: const Text('Confirm'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text('$label: $value'),
    );
  }
}
