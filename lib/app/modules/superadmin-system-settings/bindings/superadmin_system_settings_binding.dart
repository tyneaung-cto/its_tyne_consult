import 'package:get/get.dart';

import '../controllers/superadmin_system_settings_controller.dart';

class SuperadminSystemSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperadminSystemSettingsController>(
      () => SuperadminSystemSettingsController(),
    );
  }
}
