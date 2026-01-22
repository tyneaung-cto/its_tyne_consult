import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_tyne_consult/app/data/models/session_model.dart';

class MySessionsController extends GetxController {
  // ======================================================
  // 🔹 Current User
  // ======================================================

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ======================================================
  // 🔹 Filters (optional future use)
  // ======================================================

  final selectedStatus = 'all'.obs; // all | upcoming | completed | cancelled

  void setStatus(String status) {
    selectedStatus.value = status;
    debugPrint('🔄 MySessions status filter -> $status');
  }

  // ======================================================
  // 🔹 Stream (REAL DATA FROM FIRESTORE)
  // ======================================================

  Stream<List<ConsultationSession>> mySessionsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    debugPrint('🚀 mySessionsStream() subscribed for uid=$uid');

    // Safety: no user logged in
    if (uid == null || uid.isEmpty) {
      debugPrint('❌ No logged-in user. Returning empty stream.');
      return Stream.value([]);
    }

    // 🚨 IMPORTANT:
    // Do NOT use asyncExpand / selectedStatus.stream here.
    // It can cause stream not to emit → infinite loading.
    // Just return ONE direct Firestore stream.

    Query query = FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: uid)
        .orderBy('scheduledAt', descending: true);

    debugPrint(
      '📡 Firestore query: sessions where userId=$uid orderBy scheduledAt DESC',
    );

    return query
        .snapshots()
        .map((snapshot) {
          debugPrint('🔥 Snapshot received');
          debugPrint('📄 docs count = ${snapshot.docs.length}');

          final sessions = snapshot.docs.map((doc) {
            debugPrint('   • docId=${doc.id}');
            debugPrint('     data=${doc.data()}');
            return ConsultationSession.fromDoc(doc);
          }).toList();

          // Optional client-side status filter (safe)
          final status = selectedStatus.value;
          if (status != 'all') {
            final filtered = sessions.where((s) => s.status == status).toList();
            debugPrint(
              '🔎 After status filter ($status) -> ${filtered.length}',
            );
            return filtered;
          }

          debugPrint('✅ Returning sessions -> ${sessions.length}');
          return sessions;
        })
        .handleError((e, stack) {
          debugPrint('❌ mySessionsStream ERROR: $e');
          debugPrint(stack.toString());
        });
  }

  // ======================================================
  // 🔹 Helpers
  // ======================================================

  bool isUpcoming(ConsultationSession s) => s.status == 'upcoming';
  bool isCompleted(ConsultationSession s) => s.status == 'completed';
  bool isCancelled(ConsultationSession s) => s.status == 'cancelled';
}
