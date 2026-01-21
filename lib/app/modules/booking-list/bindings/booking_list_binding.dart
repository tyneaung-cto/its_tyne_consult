import 'package:get/get.dart';

import '../controllers/booking_list_controller.dart';

class BookingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingListController>(
      () => BookingListController(),
    );
  }
}
