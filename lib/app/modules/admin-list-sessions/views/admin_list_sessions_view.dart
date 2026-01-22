import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:its_tyne_consult/app/data/models/session_model.dart';

import '../controllers/admin_list_sessions_controller.dart';

class AdminListSessionsView extends GetView<AdminListSessionsController> {
  const AdminListSessionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sessions'), centerTitle: true),
      body: Column(
        children: [
          // =========================
          // 🔍 Filters Section
          // =========================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final range = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (range != null) {
                            controller.setDateRange(range.start, range.end);
                          }
                        },
                        icon: const Icon(Icons.date_range),
                        label: const Text('Date Range'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: 'all',
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(
                            value: 'upcoming',
                            child: Text('Upcoming'),
                          ),
                          DropdownMenuItem(
                            value: 'completed',
                            child: Text('Completed'),
                          ),
                          DropdownMenuItem(
                            value: 'cancelled',
                            child: Text('Cancelled'),
                          ),
                        ],
                        onChanged: (v) =>
                            controller.setStatusFilter(v ?? 'all'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =========================
          // 📋 Sessions List
          // =========================
          Expanded(
            child: StreamBuilder<List<ConsultationSession>>(
              stream: controller.sessionsStream(),
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    (snapshot.data == null || snapshot.data!.isEmpty)) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final sessions = snapshot.data ?? [];

                if (sessions.isEmpty) {
                  return const Center(child: Text('No sessions found'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final s = sessions[index];
                    final hasLink = s.meetingLink.isNotEmpty;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: s.status == 'upcoming'
                          ? (hasLink
                                ? Colors.green.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.18))
                          : s.status == 'completed'
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.10)
                          : Theme.of(
                              context,
                            ).colorScheme.error.withOpacity(0.10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status
                            Text(
                              'Status: ${s.status.toUpperCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: s.status == 'completed'
                                    ? Theme.of(context).colorScheme.primary
                                    : s.status == 'cancelled'
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // User
                            Text(
                              'User: ${s.userId}',
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 6),

                            // Time + duration
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${s.scheduledAt} • ${s.duration} mins',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),

                            // Meeting link
                            if (s.meetingLink.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Link: ${s.meetingLink}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),

                            // Actions
                            if (s.status == 'upcoming')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Set/Edit Link button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hasLink
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final controllerText =
                                          TextEditingController(
                                            text: hasLink ? s.meetingLink : '',
                                          );

                                      final link = await showDialog<String>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(
                                            hasLink
                                                ? 'Edit Meeting Link'
                                                : 'Set Meeting Link',
                                          ),
                                          content: TextField(
                                            controller: controllerText,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'https://meet.google.com/...',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(
                                                ctx,
                                                controllerText.text.trim(),
                                              ),
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (link != null && link.isNotEmpty) {
                                        controller.updateMeetingLink(
                                          sessionId: s.id,
                                          link: link,
                                        );
                                      }
                                    },
                                    child: Text(
                                      hasLink ? 'Edit Link' : 'Set Link',
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Complete button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        controller.markSessionComplete(s.id),
                                    child: const Text('Complete'),
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
            ),
          ),
        ],
      ),
    );
  }
}
