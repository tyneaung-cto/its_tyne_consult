import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:its_tyne_consult/app/core/services/firestore_service.dart';
import 'package:its_tyne_consult/app/data/models/consultation_model.dart';

class SuperadminHomeController extends GetxController {
  //TODO: Implement SuperadminHomeController

  final count = 0.obs;

  /// 🔽 Consultation status filter (default = pending)
  /// pending | confirmed | cancelled | rejected | all
  final RxString selectedStatus = 'pending'.obs;

  /// Change filter from UI chips/buttons
  void setStatusFilter(String status) {
    selectedStatus.value = status;
    debugPrint('🔄 Trigger new stream for status: $status');
    debugPrint('🟡 Status filter changed -> $status');
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  /// 🔽 Stream consultations based on selectedStatus filter
  /// OPTION A (simple & stable):
  /// Rebuild stream each time UI rebuilds (called inside Obx/StreamBuilder)
  Stream<List<Consultation>> consultationsStream() {
    final status = selectedStatus.value;

    debugPrint('🟡 Loading consultations with status = $status');

    Query query = FirebaseFirestore.instance.collection('consultations');

    // filter
    if (status != 'all') {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      final list = snapshot.docs
          .map((doc) => Consultation.fromDoc(doc))
          .toList();

      // 🔥 debug print every time stream updates
      debugPrint('📦 Stream emitted ${list.length} consultations');
      for (final c in list) {
        debugPrint('   • ${c.id} | ${c.status}');
      }

      return list;
    });
  }

  /// Update consultation status (confirmed / cancelled / rejected)
  /// Also handles extra logic like notifications & FCM
  Future<void> updateConsultationStatus({
    required String consultationId,
    required String userId,
    required String status, // confirmed | cancelled | rejected
  }) async {
    try {
      debugPrint('🟡 Update consultation: $consultationId -> $status');

      final now = DateTime.now();

      // 1️⃣ Update Firestore consultation document
      await FirebaseFirestore.instance
          .collection('consultations')
          .doc(consultationId)
          .update({
            'status': status,
            'actionBy': AuthService().getCurrentUser()?.uid,
            'actionTime': Timestamp.fromDate(now),
          });

      // 2️⃣ Save notification record for user
      await FirestoreService.instance.createUserNotification(
        userId: userId,
        title: 'Consultation Update',
        message: 'Your consultation was $status',
        createdAt: now,
      );

      // 3️⃣ Send FCM topic push (role topic or personal topic)
      await FirestoreService.instance.sendFcmPushToTopic(
        topic: userId, // personal topic (uid-based)
        title: 'Consultation $status',
        message: 'Your request has been $status',
      );

      debugPrint('✅ Consultation updated successfully');
    } catch (e) {
      debugPrint('❌ updateConsultationStatus error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    // Implement logout logic here
    // For example, call AuthService().signOut() and navigate to login page
    await AuthService().signOut();
  }
}
