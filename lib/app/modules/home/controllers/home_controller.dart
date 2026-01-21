import 'package:get/get.dart';

class HomeController extends GetxController {
  /// Navigate to booking page
  void goToBooking() {
    Get.toNamed('/booking');
  }

  void goToBookingList() {
    Get.toNamed('/booking-list');
  }

  /// Navigate to user's sessions page
  void goToMySessions() {
    Get.toNamed('/my-sessions');
  }

  @override
  void onInit() {
    super.onInit();
    // Future: load dashboard data, upcoming sessions, etc.
  }
}
