import 'package:get/get.dart';

import '../controllers/banned_home_controller.dart';

class BannedHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BannedHomeController>(
      () => BannedHomeController(),
    );
  }
}
