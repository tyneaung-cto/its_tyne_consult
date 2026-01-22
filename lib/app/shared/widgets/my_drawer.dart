import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/constants/app_constants.dart';
import 'package:its_tyne_consult/app/core/services/auth_service.dart';
import 'package:its_tyne_consult/app/core/values/app_spacing.dart';
import 'package:its_tyne_consult/app/modules/profile/controllers/profile_controller.dart';
import 'package:its_tyne_consult/app/shared/widgets/drawer_list_tile.dart';
import 'package:its_tyne_consult/app/shared/widgets/my_divider.dart';

class MyDrawer extends StatefulWidget {
  final bool? isUser;

  const MyDrawer({super.key, this.isUser = true});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return (widget.isUser ?? true)
        ? Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // user avatar
                            // AuthService().getCurrentAvatar() != ''
                            //     ? CircleAvatar(
                            //         radius: 40,
                            //         backgroundImage: NetworkImage(
                            //           AuthService().getCurrentAvatar(),
                            //         ),
                            //       )
                            //     : CircleAvatar(
                            //         radius: 40,
                            //         backgroundColor: Theme.of(
                            //           context,
                            //         ).colorScheme.onPrimary.withOpacity(0.2),
                            //         child: Icon(
                            //           Icons.person,
                            //           size: 80,
                            //           color: Theme.of(context).colorScheme.onPrimary,
                            //         ),
                            //       ),
                            Obx(() {
                              final imageUrl = profileController.profileImage.value;

                              if (imageUrl != null && imageUrl.isNotEmpty) {
                                return CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(imageUrl),
                                  backgroundColor: Colors.transparent,
                                );
                              }

                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withValues(
                                      alpha: 0.2,
                                    ), // replaces withOpacity
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              );
                            }),
                            AppSpacing.h12,
                            Text(
                              AuthService().getCurrentEmail() ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      DrawerListTile(
                        title: 'Home',
                        icon: Icons.home,
                        onTap: () {
                          Get.back();
                        },
                      ),
                      DrawerListTile(
                        title: 'Profile',
                        icon: Icons.person,
                        onTap: () {
                          Get.toNamed('/profile');
                        },
                      ),
                      DrawerListTile(
                        title: 'Settings',
                        icon: Icons.settings,
                        onTap: () {
                          Get.toNamed('/setting');
                        },
                      ),

                      MyDivider(),
                      DrawerListTile(
                        title: "Request Account Deletion",
                        icon: Icons.delete_forever,
                        isIconRed: true,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: "Logout",
                        icon: Icons.logout,
                        isIconRed: true,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onTap: AuthService().signOut,
                      ),
                    ],
                  ),
                ),
                // App version
                Text(
                  AppConstants.appVersion,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),

                // Footer
                Text(
                  'ItsTyne Consult © 2026',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                AppSpacing.h16,
              ],
            ),
          )
        : Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // user avatar
                            // AuthService().getCurrentAvatar() != ''
                            //     ? CircleAvatar(
                            //         radius: 40,
                            //         backgroundImage: NetworkImage(
                            //           AuthService().getCurrentAvatar(),
                            //         ),
                            //       )
                            //     : CircleAvatar(
                            //         radius: 40,
                            //         backgroundColor: Theme.of(
                            //           context,
                            //         ).colorScheme.onPrimary.withOpacity(0.2),
                            //         child: Icon(
                            //           Icons.person,
                            //           size: 80,
                            //           color: Theme.of(context).colorScheme.onPrimary,
                            //         ),
                            //       ),
                            Obx(() {
                              final imageUrl = profileController.profileImage.value;

                              if (imageUrl != null && imageUrl.isNotEmpty) {
                                return CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(imageUrl),
                                  backgroundColor: Colors.transparent,
                                );
                              }

                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withValues(
                                      alpha: 0.2,
                                    ), // replaces withOpacity
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              );
                            }),
                            AppSpacing.h12,

                            Text(
                              AuthService().getCurrentEmail() ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      DrawerListTile(
                        title: 'Home',
                        icon: Icons.home,
                        onTap: () {
                          Get.back();
                        },
                      ),
                      DrawerListTile(
                        title: 'Profile',
                        icon: Icons.person,
                        onTap: () {
                          Get.toNamed('/profile');
                        },
                      ),
                      DrawerListTile(
                        title: 'Settings',
                        icon: Icons.settings,
                        onTap: () {
                          Get.toNamed('/setting');
                        },
                      ),

                      MyDivider(),

                      // admin specific options
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Admin Options',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      DrawerListTile(
                        title: 'User Management',
                        icon: Icons.people,
                        onTap: () {
                          Get.toNamed('/superadmin-user-management');
                        },
                      ),
                      DrawerListTile(
                        title: 'System Settings',
                        icon: Icons.settings,
                        onTap: () {
                          Get.toNamed('/superadmin-system-settings');
                        },
                      ),
                      DrawerListTile(
                        title: 'Send Notifications',
                        icon: Icons.notifications,
                        onTap: () {
                          Get.toNamed('/superadmin-list-notifications');
                        },
                      ),
                      MyDivider(),

                      // Admin cannot request account deletion
                      // DrawerListTile(
                      //   title: "Request Account Deletion",
                      //   icon: Icons.delete_forever,
                      //   isIconRed: true,
                      //   textStyle: TextStyle(
                      //     color: Theme.of(context).colorScheme.error,
                      //   ),
                      //   onTap: () {},
                      // ),
                      DrawerListTile(
                        title: "Logout",
                        icon: Icons.logout,
                        isIconRed: true,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onTap: AuthService().signOut,
                      ),
                    ],
                  ),
                ),
                // App version
                Text(
                  AppConstants.appVersion,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),

                // Footer
                Text(
                  'ItsTyne Consult © 2026',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                AppSpacing.h16,
              ],
            ),
          );
  }
}
