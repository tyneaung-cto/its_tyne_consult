import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:its_tyne_consult/app/data/models/session_model.dart';

class AdminListSessionsController extends GetxController {
  // ======================================================
  // 🔹 Filters
  // ======================================================

  /// upcoming | completed | cancelled | all
  final selectedStatus = 'upcoming'.obs;

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  void setStatus(String status) {
    selectedStatus.value = status;
    debugPrint('🔄 Session status filter -> $status');
  }

  /// Alias for UI consistency (same behavior as setStatus)
  void setStatusFilter(String status) {
    selectedStatus.value = status;
    debugPrint('🔄 Session status filter (setStatusFilter) -> $status');
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    debugPrint('📅 Session date range -> $start ~ $end');
  }

  void clearFilters() {
    selectedStatus.value = 'upcoming';
    startDate.value = null;
    endDate.value = null;
  }

  // ======================================================
  // 🔹 Sessions Stream
  // ======================================================

  Stream<List<ConsultationSession>> sessionsStream() {
    debugPrint('🚀 sessionsStream() subscribed');

    // 🔥 IMPORTANT:
    // Rx.stream DOES NOT emit initial value.
    // So we must manually emit first query, then listen to changes.

    Stream<List<ConsultationSession>> load(String status) {
      debugPrint('🟡 Loading sessions with status = $status');
      debugPrint(
        '📅 startDate = ${startDate.value}, endDate = ${endDate.value}',
      );

      Query query = FirebaseFirestore.instance.collection('sessions');

      // Status filter
      if (status != 'all') {
        debugPrint('🔎 Applying status filter: $status');
        query = query.where('status', isEqualTo: status);
      } else {
        debugPrint('🔎 Status filter skipped (all)');
      }

      // Sorting
      debugPrint('📊 Applying orderBy scheduledAt');
      query = query.orderBy('scheduledAt');

      return query.snapshots().map((snapshot) {
        debugPrint('🔥 Firestore snapshot received');
        debugPrint('📄 docs count = ${snapshot.docs.length}');

        final sessions = snapshot.docs.map((doc) {
          debugPrint('   • docId=${doc.id} data=${doc.data()}');
          return ConsultationSession.fromDoc(doc);
        }).toList();

        // Date filtering (client side)
        final filtered = sessions.where((s) {
          if (startDate.value != null &&
              s.scheduledAt.isBefore(startDate.value!)) {
            debugPrint('⛔ filtered by startDate -> ${s.id}');
            return false;
          }

          if (endDate.value != null && s.scheduledAt.isAfter(endDate.value!)) {
            debugPrint('⛔ filtered by endDate -> ${s.id}');
            return false;
          }

          return true;
        }).toList();

        debugPrint('✅ Sessions after filter: ${filtered.length}');
        return filtered;
      });
    }

    // 🔥 Emit immediately + listen for future changes
    return Stream.multi((controller) {
      // initial load
      load(selectedStatus.value).listen(controller.add);

      // subsequent status changes
      selectedStatus.stream.listen((status) {
        load(status).listen(controller.add);
      });
    });
  }

  // ======================================================
  // 🔹 Actions
  // ======================================================

  Future<void> markSessionComplete(String sessionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .update({'status': 'completed'});

      debugPrint('✅ Session marked completed -> $sessionId');
    } catch (e) {
      debugPrint('❌ markSessionComplete error: $e');
    }
  }

  Future<void> updateMeetingLink({
    required String sessionId,
    required String link,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .update({'meetingLink': link});

      debugPrint('🔗 Meeting link updated -> $sessionId');
    } catch (e) {
      debugPrint('❌ updateMeetingLink error: $e');
    }
  }
}
