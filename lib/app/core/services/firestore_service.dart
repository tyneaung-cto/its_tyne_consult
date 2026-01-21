import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_tyne_consult/app/data/models/consultation_model.dart';
import 'package:its_tyne_consult/app/data/models/notification_model.dart';

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
          (snapshot) => snapshot.docs
              .map((doc) => Consultation.fromDoc(doc))
              .toList(),
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
          (snapshot) => snapshot.docs
              .map((doc) => AppNotification.fromDoc(doc))
              .toList(),
        );
  }

  /// Mark notification as read (future use)
  Future<void> markNotificationAsRead(String notificationId) async {
    await _db
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
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
}
