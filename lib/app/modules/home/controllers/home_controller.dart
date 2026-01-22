import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:its_tyne_consult/app/core/services/auth_service.dart';

class HomeController extends GetxController {
  // ======================================================
  // 🔹 Dashboard counters (auto update via Firestore stream)
  // ======================================================

  final bookingsCount = 0.obs;
  final sessionsCount = 0.obs;
  final notificationsUnreadCount = 0.obs;

  // 🔹 Upcoming sessions (max 5, today → future only)
  final upcomingSessions = <Map<String, dynamic>>[].obs;
  StreamSubscription? _upcomingSub;

  StreamSubscription? _bookingSub;
  StreamSubscription? _sessionSub;
  StreamSubscription? _notificationSub;

  void _listenCounts() {
    final uid = AuthService().getCurrentUser()?.uid;

    debugPrint('🏠 HomeController listenCounts uid=$uid');
    debugPrint('📡 Starting Firestore listeners for dashboard counters');

    if (uid == null) return;

    // 🔵 Bookings count (FIXED: handle userId / userID mismatch + better logging)
    _bookingSub = FirebaseFirestore.instance
        .collection('consultations')
        .snapshots()
        .listen(
          (snap) {
            debugPrint('🔥 bookings snapshot received (raw)');
            debugPrint('📄 total consultation docs = ${snap.docs.length}');

            int count = 0;

            for (final d in snap.docs) {
              final data = d.data() as Map<String, dynamic>;

              // Some docs use userId, some userID (common bug)
              final docUid = data['userId'] ?? data['userID'];

              debugPrint('   • bookingId=${d.id} user=$docUid data=$data');

              if (docUid == uid) {
                count++;
              }
            }

            bookingsCount.value = count;
            debugPrint('📊 bookingsCount updated (filtered) -> $count');
          },
          onError: (e) {
            debugPrint('❌ bookings listener error: $e');
          },
        );

    // 🟢 Sessions count
    _sessionSub = FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen(
          (snap) {
            debugPrint('🔥 sessions snapshot received');
            debugPrint('📄 sessions docs count = ${snap.docs.length}');
            for (final d in snap.docs) {
              debugPrint('   • sessionId=${d.id} data=${d.data()}');
            }

            sessionsCount.value = snap.docs.length;
            debugPrint('📊 sessionsCount updated -> ${sessionsCount.value}');
          },
          onError: (e) {
            debugPrint('❌ sessions listener error: $e');
          },
        );

    /// 🔴 Notifications unread count
    _notificationSub = FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen(
          (snap) {
            debugPrint('🔥 notifications snapshot received');
            debugPrint('📄 unread notifications count = ${snap.docs.length}');
            for (final d in snap.docs) {
              debugPrint('   • notificationId=${d.id} data=${d.data()}');
            }

            notificationsUnreadCount.value = snap.docs.length;
            debugPrint(
              '📊 notificationsUnreadCount updated -> ${notificationsUnreadCount.value}',
            );
          },
          onError: (e) {
            debugPrint('❌ notifications listener error: $e');
          },
        );

    // 🟣 Upcoming sessions (today → future, max 5)
    final now = DateTime.now();

    _upcomingSub = FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: uid)
        .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('scheduledAt')
        .limit(5)
        .snapshots()
        .listen(
          (snap) {
            debugPrint('🔥 upcoming sessions snapshot received');
            debugPrint('📄 upcoming docs count = ${snap.docs.length}');

            for (final d in snap.docs) {
              debugPrint('   • upcomingId=${d.id} data=${d.data()}');
            }

            final mapped = snap.docs.map((d) {
              final data = d.data() as Map<String, dynamic>;
              data['id'] = d.id; // keep doc id for UI
              return data;
            }).toList();

            upcomingSessions.assignAll(mapped);
            debugPrint(
              '📊 upcomingSessions updated -> ${upcomingSessions.length}',
            );
          },
          onError: (e) {
            debugPrint('❌ upcoming sessions listener error: $e');
          },
        );
  }

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
    _listenCounts();
    // Future: load dashboard data, upcoming sessions, etc.
  }

  @override
  void onClose() {
    _bookingSub?.cancel();
    _sessionSub?.cancel();
    _notificationSub?.cancel();
    _upcomingSub?.cancel();
    super.onClose();
  }
}
