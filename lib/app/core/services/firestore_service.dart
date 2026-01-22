import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_tyne_consult/app/data/models/app_user_model.dart';
import 'package:its_tyne_consult/app/data/models/consultation_model.dart';
import 'package:its_tyne_consult/app/data/models/app_notification_model.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createConsultation(Consultation consultation) async {
    await _db.collection('consultations').add(consultation.toMap());
  }

  /// Stream consultations for a specific user (Booking List)
  Stream<List<Consultation>> streamUserConsultations(String userId) {
    return _db
        .collection('consultations')
        .where('userID', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Consultation.fromDoc(doc)).toList(),
        );
  }

  /// Fetch notifications for current user
  Stream<List<AppNotification>> getUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => AppNotification.fromDoc(doc)).toList(),
        );
  }

  /// Mark notification as read (future use)
  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  Future<void> createUser({
    required User firebaseUser,
    required String username,
  }) async {
    try {
      debugPrint('🟡 Firestore: createUser start');

      await _db.collection('users').doc(firebaseUser.uid).set({
        'username': username,
        'email': firebaseUser.email,
        'role': 'client',
        'isActive': true,
        'isBanned': false,
        'profile_image': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Firestore: user document created');
    } catch (e, s) {
      debugPrint('❌ Firestore createUser error: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }

  Future<bool> userExists(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists;
  }

  Future<bool> isUserBanned(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      return data?['isBanned'] ?? false;
    }
    return false;
  }

  Future<bool> isRequestedDel(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      return data?['requestDel'] ?? false;
    }
    return false;
  }

  Future<bool> isUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      final role = data?['role'] ?? '';
      return role == 'client';
    }
    return false;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found.');
    }
    return _db.collection('users').doc(currentUser.uid).get();
  }

  /// Get current user document
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    return _db.collection('users').doc(user.uid).get();
  }

  /// Update user fields (e.g. username, profile_image)
  Future<void> updateUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      debugPrint('🟡 Firestore: updateUser start -> $uid');
      debugPrint('🟡 Update data: $data');

      await _db.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Firestore: user updated successfully');
    } catch (e, s) {
      debugPrint('❌ Firestore updateUser error: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }

  /// Stream all users (SuperAdmin – User Management)
  Stream<List<AppUser>> streamAllUsers() {
    return _db
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => AppUser.fromDoc(doc)).toList(),
        );
  }

  /// Stream all notifications (SuperAdmin – Sent notifications)
  Stream<List<AppNotification>> streamAllNotifications({int limit = 100}) {
    return _db
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => AppNotification.fromDoc(doc)).toList(),
        );
  }

  /// Create notifications by target audience
  /// target can be: 'all', 'clients', 'consultants', 'admins', 'superadmins'
  Future<void> createGlobalNotificationByTarget({
    required String target,
    required String title,
    required String message,
    required bool isRead,
    required DateTime createdAt,
  }) async {
    try {
      debugPrint('================ NOTIFICATION DEBUG ================');
      debugPrint('🟡 Firestore: createGlobalNotificationByTarget start');
      debugPrint('🟡 Target audience from controller: $target');
      debugPrint('🟡 Title: $title');
      debugPrint('🟡 Message: $message');

      Query query = _db
          .collection('users')
          .where('isActive', isEqualTo: true)
          .where('isBanned', isEqualTo: false);

      // Normalize target (allow singular/plural + lowercase)
      final normalized = target.toLowerCase();

      switch (normalized) {
        case 'client':
          query = query.where('role', isEqualTo: 'client');
          break;

        case 'consultant':
          query = query.where('role', isEqualTo: 'consultant');
          break;

        case 'admin':
          query = query.where('role', isEqualTo: 'admin');
          break;

        case 'superadmin':
          query = query.where('role', isEqualTo: 'superadmin');
          break;

        case 'all':
        default:
          // already filtered only active + not banned
          break;
      }

      final usersSnapshot = await query.get();

      debugPrint('🟡 Matched users count: ${usersSnapshot.docs.length}');

      final batch = _db.batch();

      int index = 0;

      for (final doc in usersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final email = data['email'] ?? '';
        final role = data['role'] ?? '';

        debugPrint('➡️ [$index] uid=${doc.id} | email=$email | role=$role');

        final ref = _db.collection('notifications').doc();

        batch.set(ref, {
          'userId': doc.id,
          'title': title,
          'message': message,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        index++;
      }

      await batch.commit();

      debugPrint('✅ Firestore: notifications created for target=$target');
      debugPrint('====================================================');
    } catch (e, s) {
      debugPrint('❌ Firestore createGlobalNotificationByTarget error: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }

  Future<void> sendFcmPushToTopic({
    required String topic,
    required String title,
    required String message,
  }) async {
    try {
      debugPrint('🟡 Sending FCM push to topic: $topic');

      // IMPORTANT: use same region as deployed Cloud Function (fixes UNAVAILABLE error)
      final functions = FirebaseFunctions.instanceFor(region: 'us-central1');

      // final callable = functions.httpsCallable('sendTopicNotification');
      final callable = functions.httpsCallable('sendFcmToTokens');

      await callable.call({'topic': topic, 'title': title, 'message': message});

      debugPrint('✅ FCM push sent');
    } catch (e) {
      debugPrint('❌ FCM push error: $e');
    }
  }

  Future<void> createGlobalNotificationForUsers({
    required List<String> userIds,
    required String title,
    required String message,
  }) async {
    final batch = _db.batch();

    for (final uid in userIds) {
      final ref = _db.collection('notifications').doc();
      batch.set(ref, {
        'userId': uid,
        'title': title,
        'message': message,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// Create single user notification (used by controllers like register, consultation, etc.)
  Future<void> createUserNotification({
    required String userId,
    required String title,
    required String message,
    required DateTime createdAt,
  }) async {
    try {
      debugPrint('🟡 Firestore: createUserNotification -> $userId');

      await _db.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Firestore: user notification created');
    } catch (e, s) {
      debugPrint('❌ Firestore createUserNotification error: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }
}
