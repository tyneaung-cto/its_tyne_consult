import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:its_tyne_consult/app/core/services/auth_service.dart';

class RequestDelHomeController extends GetxController {
  final _auth = AuthService();
  final _db = FirebaseFirestore.instance;

  // ======================================================
  // 🔹 User Info
  // ======================================================

  final uid = ''.obs;
  final email = ''.obs;
  final username = ''.obs;

  final requestDel = false.obs;
  final requestDelApplyDate = Rxn<DateTime>();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;

  // ======================================================
  // 🔹 Lifecycle
  // ======================================================

  @override
  void onInit() {
    super.onInit();

    final user = _auth.getCurrentUser();
    if (user == null) return;

    uid.value = user.uid;
    email.value = user.email ?? '';

    _listenUser();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  // ======================================================
  // 🔹 Firestore Listener
  // ======================================================

  void _listenUser() {
    debugPrint('🟡 RequestDelHome: listening user -> ${uid.value}');

    _sub = _db
        .collection('users')
        .doc(uid.value)
        .snapshots()
        .listen(
          (doc) {
            if (!doc.exists) return;

            final data = doc.data()!;

            username.value = data['username'] ?? '';
            requestDel.value = data['requestDel'] ?? false;

            if (data['requestDelApplyDate'] != null) {
              requestDelApplyDate.value =
                  (data['requestDelApplyDate'] as Timestamp).toDate();
            } else {
              requestDelApplyDate.value = null;
            }

            debugPrint(
              '✅ RequestDelHome loaded -> requestDel=${requestDel.value}, date=${requestDelApplyDate.value}',
            );
          },
          onError: (e) {
            debugPrint('❌ RequestDelHome listener error: $e');
          },
        );
  }

  // ======================================================
  // 🔹 Actions
  // ======================================================

  Future<void> cancelDeletionRequest() async {
    try {
      await _db.collection('users').doc(uid.value).update({
        'requestDel': false,
        'requestDelApplyDate': null,
      });

      debugPrint('✅ Deletion request cancelled');
      Get.snackbar('Cancelled', 'Account deletion request has been cancelled');
    } catch (e) {
      debugPrint('❌ cancelDeletionRequest error: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
