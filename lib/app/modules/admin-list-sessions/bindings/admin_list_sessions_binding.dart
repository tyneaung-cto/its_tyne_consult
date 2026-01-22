import 'package:get/get.dart';

import '../controllers/admin_list_sessions_controller.dart';

class AdminListSessionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminListSessionsController>(
      () => AdminListSessionsController(),
    );
  }
}
