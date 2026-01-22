import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:its_tyne_consult/app/core/values/app_spacing.dart';
import 'package:its_tyne_consult/app/shared/widgets/my_drawer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('ItsTyne Consult'),
      //   centerTitle: false,
      //   actions: [
      //     IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
      //   ],
      // ),
      drawer: const MyDrawer(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToBooking,
        icon: const Icon(Icons.schedule_outlined),
        label: Text('request'.tr),
        tooltip: 'Request Consultation',
      ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              Obx(() {
                final unread = controller.notificationsUnreadCount.value;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Get.toNamed('/notifications');
                      },
                      tooltip: 'Notifications',
                    ),

                    if (unread > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(minWidth: 18),
                          child: Text(
                            unread > 99 ? '99+' : '$unread',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onError,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
            pinned: true,
            floating: false,
            expandedHeight: 120,
            title: Text(
              'ItsTyne Consult',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome section
                Text(
                  'home_welcome_title'.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AppSpacing.h8,
                Text(
                  'home_welcome_subtitle'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.h24,

                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => _QuickActionCard(
                          icon: Icons.schedule,
                          title: 'home_book_session'.tr,
                          subtitle: '30 / 40 minutes',
                          count: controller.bookingsCount.value,
                          onTap: controller.goToBookingList,
                        ),
                      ),
                    ),

                    AppSpacing.w16,

                    Expanded(
                      child: Obx(
                        () => _QuickActionCard(
                          icon: Icons.history,
                          title: 'home_my_sessions'.tr,
                          subtitle: 'home_view_history'.tr,
                          count: controller.sessionsCount.value,
                          onTap: controller.goToMySessions,
                        ),
                      ),
                    ),
                  ],
                ),

                AppSpacing.h24,

                // Upcoming section
                Text(
                  'home_upcoming_title'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppSpacing.h12,
                Obx(() {
                  final sessions = controller.upcomingSessions;

                  if (sessions.isEmpty) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.event_available),
                        title: Text('home_no_upcoming'.tr),
                        subtitle: Text('home_no_upcoming_desc'.tr),
                        trailing: TextButton(
                          onPressed: controller.goToBooking,
                          child: Text('home_book_now'.tr),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: controller.upcomingSessions.map((session) {
                      final dt = (session['scheduledAt']).toDate();
                      final duration = session['duration'];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.schedule),
                          title: Text('${dt.day}/${dt.month}/${dt.year}'),
                          subtitle: Text(
                            'Time ${TimeOfDay.fromDateTime(dt).format(context)} • $duration mins',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: controller.goToMySessions,
                        ),
                      );
                    }).toList(),
                  );
                }),
                AppSpacing.h24,

                // How it works
                Text(
                  'home_how_it_works'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppSpacing.h12,
                Card(
                  child: Column(
                    children: [
                      // one
                      ListTile(
                        leading: Icon(Icons.looks_one_outlined),
                        title: Text('home_step_1_title'.tr),
                        subtitle: Text('home_step_1_desc'.tr),
                      ),
                      Divider(height: 1),

                      // two
                      ListTile(
                        leading: Icon(Icons.looks_two_outlined),
                        title: Text('home_step_2_title'.tr),
                        subtitle: Text('home_step_2_desc'.tr),
                      ),
                      Divider(height: 1),

                      // three
                      ListTile(
                        leading: Icon(Icons.looks_3_outlined),
                        title: Text('home_step_3_title'.tr),
                        subtitle: Text('home_step_3_desc'.tr),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h24,

                // Why choose ItsTyne
                // Text(
                //   'Why Choose ItsTyne Consult',
                //   style: Theme.of(context).textTheme.titleMedium,
                // ),
                // AppSpacing.h12,
                // Row(
                //   children: const [
                //     Expanded(
                //       child: _InfoCard(
                //         icon: Icons.verified_outlined,
                //         title: 'Professional',
                //         subtitle: 'Experienced consultation',
                //       ),
                //     ),
                //     SizedBox(width: 16),
                //     Expanded(
                //       child: _InfoCard(
                //         icon: Icons.schedule_outlined,
                //         title: 'Flexible',
                //         subtitle: 'Simple scheduling',
                //       ),
                //     ),
                //   ],
                // ),
                // AppSpacing.h32,
                Center(
                  child: Text(
                    'Free consultation sessions are subject to availability.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                AppSpacing.h32,
                AppSpacing.h32,
                AppSpacing.h32,
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32),
              AppSpacing.h16,
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              AppSpacing.h4,
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.h4,
              if (count > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GFBadge(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(
                        count.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28),
            AppSpacing.h12,
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            AppSpacing.h4,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
