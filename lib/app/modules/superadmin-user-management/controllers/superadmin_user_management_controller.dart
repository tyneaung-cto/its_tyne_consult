import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:its_tyne_consult/app/data/models/app_user_model.dart';

import '../../../core/services/firestore_service.dart';

class SuperadminUserManagementController extends GetxController {
  final isLoading = true.obs;
  final users = <AppUser>[].obs;
  final filteredUsers = <AppUser>[].obs;
  final activeFilter = 'all'.obs; // all | active | banned | admin | superadmin | consultant | client

  StreamSubscription<List<AppUser>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listenUsers();
  }

  void _listenUsers() {
    isLoading.value = true;

    _subscription = FirestoreService.instance
        .streamAllUsers()
        .listen(
      (data) {
        users.assignAll(data);
        _applyFilter();
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        debugPrint('❌ User management stream error: $error');
      },
    );
  }

  Future<void> changeUserRole({
    required String userId,
    required String newRole,
  }) async {
    try {
      debugPrint('🟡 Changing role: $userId → $newRole');

      await FirestoreService.instance.updateUser(
        uid: userId,
        data: {
          'role': newRole,
          'updatedAt': Timestamp.now(),
        },
      );

      debugPrint('✅ Role updated successfully');
    } catch (e, s) {
      debugPrint('❌ Failed to change role: $e');
      debugPrint('STACKTRACE: $s');
      Get.snackbar(
        'Error',
        'Unable to update user role',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> toggleBanUser({
    required String userId,
    required bool isBanned,
  }) async {
    try {
      debugPrint(
        '🟡 ${isBanned ? 'Banning' : 'Unbanning'} user: $userId',
      );

      await FirestoreService.instance.updateUser(
        uid: userId,
        data: {
          'isBanned': isBanned,
          'updatedAt': Timestamp.now(),
        },
      );

      debugPrint('✅ User ban status updated');
    } catch (e, s) {
      debugPrint('❌ Failed to update ban status: $e');
      debugPrint('STACKTRACE: $s');
      Get.snackbar(
        'Error',
        'Unable to update user status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 🔴 Permanently delete user (SuperAdmin only)
  Future<void> deleteUser({
    required String userId,
  }) async {
    try {
      debugPrint('🟡 Deleting user completely: $userId');

      // optional confirm handled in UI
      isLoading.value = true;

      final firestore = FirebaseFirestore.instance;

      // ---------- delete notifications ----------
      final notiSnap = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in notiSnap.docs) {
        await doc.reference.delete();
      }
      debugPrint('🗑 Notifications deleted: ${notiSnap.docs.length}');

      // ---------- delete sessions ----------
      final sessionSnap = await firestore
          .collection('sessions')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in sessionSnap.docs) {
        await doc.reference.delete();
      }
      debugPrint('🗑 Sessions deleted: ${sessionSnap.docs.length}');

      // ---------- delete consultations ----------
      final consultSnap = await firestore
          .collection('consultations')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in consultSnap.docs) {
        await doc.reference.delete();
      }
      debugPrint('🗑 Consultations deleted: ${consultSnap.docs.length}');

      // ---------- delete user document ----------
      await firestore.collection('users').doc(userId).delete();
      debugPrint('🗑 User document deleted');

      // NOTE: Deleting Firebase Auth user MUST be done via Cloud Function (admin SDK)
      // because client SDK cannot delete other users.

      Get.snackbar(
        'Deleted',
        'User removed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, s) {
      debugPrint('❌ deleteUser error: $e');
      debugPrint('STACKTRACE: $s');

      Get.snackbar(
        'Error',
        'Failed to delete user',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Alias for UI usage (Filter chips, buttons, etc.)
  void setFilter(String filter) {
    setActiveFilter(filter);
  }
  void setActiveFilter(String filter) {
    activeFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    final filter = activeFilter.value;

    List<AppUser> result = List.from(users);

    switch (filter) {
      case 'active':
        result = result.where((u) => u.isActive && !u.isBanned).toList();
        break;
      case 'banned':
        result = result.where((u) => u.isBanned).toList();
        break;
      case 'admin':
        result = result.where((u) => u.role == 'admin').toList();
        break;
      case 'superadmin':
        result = result.where((u) => u.role == 'superadmin').toList();
        break;
      case 'consultant':
        result = result.where((u) => u.role == 'consultant').toList();
        break;
      case 'client':
        result = result.where((u) => u.role == 'client').toList();
        break;
      case 'all':
      default:
        // no filtering
        break;
    }

    filteredUsers.assignAll(result);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
