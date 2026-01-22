import 'package:get/get.dart';

import '../controllers/superadmin_user_management_controller.dart';

class SuperadminUserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperadminUserManagementController>(
      () => SuperadminUserManagementController(),
    );
  }
}
