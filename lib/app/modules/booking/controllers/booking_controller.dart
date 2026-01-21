import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:its_tyne_consult/app/data/models/consultation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_tyne_consult/app/core/services/firestore_service.dart';

class BookingController extends GetxController {
  // Text controllers
  final TextEditingController topicController = TextEditingController();
  final TextEditingController preferredDateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Dropdown data
  final List<String> timeSlots = [
    '09:00 AM - 09:30 AM',
    '10:00 AM - 10:30 AM',
    '11:00 AM - 11:30 AM',
    '02:00 PM - 02:40 PM',
    '03:00 PM - 03:40 PM',
  ];

  final List<int> durations = [30, 40];

  // Selected values
  final RxnString selectedTimeSlot = RxnString();
  final RxInt selectedDuration = 30.obs;

  // Loading state
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    topicController.dispose();
    preferredDateController.dispose();
    notesController.dispose();
    super.onClose();
  }

  /// Pick preferred consultation date
  Future<void> pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (pickedDate != null) {
      preferredDateController.text =
          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    }
  }

  /// Handle time slot selection
  void onTimeSlotChanged(String? value) {
    selectedTimeSlot.value = value;
  }

  /// Handle duration selection
  void onDurationChanged(int? value) {
    if (value != null) {
      selectedDuration.value = value;
    }
  }

  /// Submit booking request (demo / placeholder logic)
  // Future<void> submitBookingRequest() async {
  //   if (topicController.text.trim().isEmpty ||
  //       preferredDateController.text.isEmpty ||
  //       selectedTimeSlot.value == null) {
  //     Get.snackbar(
  //       'Missing Information',
  //       'Please fill in all required fields.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return;
  //   }

  //   try {
  //     isSubmitting.value = true;

  //     // TODO: Integrate Firestore booking submission here

  //     await Future.delayed(const Duration(seconds: 1));

  //     Get.snackbar(
  //       'Request Submitted',
  //       'Your consultation request has been submitted successfully.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );

  //     // Clear form
  //     topicController.clear();
  //     preferredDateController.clear();
  //     notesController.clear();
  //     selectedTimeSlot.value = null;
  //     selectedDuration.value = 30;
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Unable to submit request. Please try again.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }
  // Future<void> submitBookingRequest() async {
  //   if (topicController.text.trim().isEmpty ||
  //       preferredDateController.text.isEmpty ||
  //       selectedTimeSlot.value == null) {
  //     Get.snackbar(
  //       'Missing Information',
  //       'Please fill in all required fields.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return;
  //   }

  //   try {
  //     isSubmitting.value = true;

  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       throw Exception('User not authenticated');
  //     }

  //     final consultation = Consultation(
  //       id: '', // Firestore will generate this
  //       userId: user.uid,
  //       topic: topicController.text.trim(),
  //       timeSlot: selectedTimeSlot.value!,
  //       duration: selectedDuration.value,
  //       notes: notesController.text.trim(),
  //       status: 'pending',
  //       preferredDate: DateTime.parse(preferredDateController.text),
  //       createdAt: DateTime.now(),
  //       actionBy: null,
  //       actionTime: null,
  //     );

  //     await FirestoreService.instance.createConsultation(consultation);

  //     Get.snackbar(
  //       'Request Submitted',
  //       'Your consultation request has been sent.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );

  //     // Clear form
  //     topicController.clear();
  //     preferredDateController.clear();
  //     notesController.clear();
  //     selectedTimeSlot.value = null;
  //     selectedDuration.value = 30;

  //     Get.back(); // optional: return to previous screen
  //   } catch (e) {
  //     debugPrint('❌ Booking error: $e');

  //     Get.snackbar(
  //       'Error',
  //       'Unable to submit request. Please try again.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }
  Future<void> submitBookingRequest() async {
    if (topicController.text.trim().isEmpty ||
        preferredDateController.text.isEmpty ||
        selectedTimeSlot.value == null) {
      Get.snackbar(
        'Missing Information',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final consultation = Consultation(
        id: '',
        userId: user.uid,
        topic: topicController.text.trim(),
        timeSlot: selectedTimeSlot.value!,
        duration: selectedDuration.value,
        notes: notesController.text.trim(),
        status: 'pending',
        preferredDate: DateTime.parse(preferredDateController.text),
        createdAt: DateTime.now(),
        actionBy: null,
        actionTime: null,
      );

      await FirestoreService.instance.createConsultation(consultation);

      // ✅ SHOW FEEDBACK FIRST
      Get.snackbar(
        'Request Submitted',
        'Your consultation request has been sent successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );

      // Clear form
      topicController.clear();
      preferredDateController.clear();
      notesController.clear();
      selectedTimeSlot.value = null;
      selectedDuration.value = 30;

      // ✅ WAIT before navigating back
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back();
    } catch (e) {
      debugPrint('❌ Booking error: $e');

      Get.snackbar(
        'Error',
        'Unable to submit request. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
