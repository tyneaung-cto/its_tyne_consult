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
        // actions: [
        //   IconButton(
        //     tooltip: 'Logout',
        //     icon: const Icon(Icons.logout),
        //     onPressed: () async {
        //       await controller.logout();
        //     },
        //   ),
        // ],
      ),
      drawer: MyDrawer(isUser: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Consultations Section (Today & Tomorrow)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Consultations',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/admin-list-sessions');
                  },
                  child: Text('More >>'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sessions')
                    .where('status', isEqualTo: 'upcoming')
                    .orderBy('scheduledAt')
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Session load failed\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No upcoming sessions'));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      final consultationId = data['consultationId'];
                      final userId = data['userId'];
                      final duration = data['duration'] ?? 0;
                      final meetingLink = data['meetingLink'] ?? '';
                      final scheduledAt = (data['scheduledAt'] as Timestamp)
                          .toDate();

                      final isToday = DateUtils.isSameDay(
                        scheduledAt,
                        DateTime.now(),
                      );

                      final dayLabel = isToday ? 'Today' : 'Upcoming';
                      final timeFmt = DateFormat('hh:mm a');

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .get(),
                        builder: (context, userSnap) {
                          final userData =
                              userSnap.data?.data() as Map<String, dynamic>? ??
                              {};

                          final userName = userData['userName'] ?? 'Client';
                          final email = userData['email'] ?? '-';

                          final hasLink = meetingLink.isNotEmpty;

                          return SizedBox(
                            width: 260,
                            child: Card(
                              color: hasLink
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.orange.withOpacity(0.18),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status: ${data['status']} [ $dayLabel ]',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Client: $email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    if (meetingLink.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Meeting ready',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.black87),
                                      ),
                                    ],
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${timeFmt.format(scheduledAt)} • $duration mins',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        if (meetingLink.isEmpty &&
                                            data['status'] == 'upcoming') ...[
                                          SizedBox(
                                            height: 32,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                              ),
                                              onPressed: () async {
                                                final controller =
                                                    TextEditingController();

                                                final link = await showDialog<String>(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                      'Set Meeting Link',
                                                    ),
                                                    content: TextField(
                                                      controller: controller,
                                                      decoration:
                                                          const InputDecoration(
                                                            hintText:
                                                                'https://meet.google.com/...',
                                                          ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              controller.text
                                                                  .trim(),
                                                            ),
                                                        child: const Text(
                                                          'Save',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (link != null &&
                                                    link.isNotEmpty) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('sessions')
                                                      .doc(docs[index].id)
                                                      .update({
                                                        'meetingLink': link,
                                                      });
                                                }
                                              },
                                              child: const Text('Set Link'),
                                            ),
                                          ),
                                        ],
                                        if (data['status'] == 'upcoming') ...[
                                          SizedBox(
                                            height: 32,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                              ),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('sessions')
                                                    .doc(docs[index].id)
                                                    .update({
                                                      'status': 'completed',
                                                    });
                                              },
                                              child: const Text('Complete'),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
                                          ).textTheme.titleMedium,
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
                                            // Show actions ONLY for pending OR when All filter + pending item
                                            if (c.status == 'pending') ...[
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                        Colors.red,
                                                      ),
                                                ),
                                                onPressed: () => controller
                                                    .updateConsultationStatus(
                                                      consultationId: c.id,
                                                      userId: c.userId,
                                                      status: 'rejected',
                                                    ),
                                                child: const Text('Rejected'),
                                              ),
                                              AppSpacing.w12,
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
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: _statusColor(label),
        backgroundColor: _statusColor(label).withOpacity(0.12),
      ),
    );
  }

  Color _statusColor(String label) {
    switch (label.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.blueGrey;
      case 'rejected':
        return Colors.red;
      case 'all':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
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
