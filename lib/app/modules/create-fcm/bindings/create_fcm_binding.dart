import 'package:get/get.dart';

import '../controllers/create_fcm_controller.dart';

class CreateFcmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateFcmController>(
      () => CreateFcmController(),
    );
  }
}
