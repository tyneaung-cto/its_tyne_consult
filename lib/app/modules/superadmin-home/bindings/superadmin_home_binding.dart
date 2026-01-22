import 'package:get/get.dart';

import '../controllers/superadmin_home_controller.dart';

class SuperadminHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperadminHomeController>(
      () => SuperadminHomeController(),
    );
  }
}
