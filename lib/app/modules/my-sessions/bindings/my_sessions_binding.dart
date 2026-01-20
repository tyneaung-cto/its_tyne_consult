import 'package:get/get.dart';

import '../controllers/my_sessions_controller.dart';

class MySessionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MySessionsController>(
      () => MySessionsController(),
    );
  }
}
