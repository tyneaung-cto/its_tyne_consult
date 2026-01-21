import 'package:get/get.dart';
import 'package:its_tyne_consult/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/auth_gate_controller.dart';

class AuthGateBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthGateController>(
    //   () => AuthGateController(),
    // );
    Get.put<AuthGateController>(AuthGateController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
