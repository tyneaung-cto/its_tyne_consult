import 'package:get/get.dart';

import '../controllers/superadmin_list_notifications_controller.dart';

class SuperadminListNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperadminListNotificationsController>(
      () => SuperadminListNotificationsController(),
    );
  }
}
