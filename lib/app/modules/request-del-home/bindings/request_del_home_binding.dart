import 'package:get/get.dart';

import '../controllers/request_del_home_controller.dart';

class RequestDelHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestDelHomeController>(
      () => RequestDelHomeController(),
    );
  }
}
