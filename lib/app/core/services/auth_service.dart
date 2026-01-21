import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_tyne_consult/app/core/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get userStream => _auth.authStateChanges();

  // Sing in with email and password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error in signInWithEmailAndPassword: $e');
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      debugPrint('🟡 Register start');

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) return null;
      debugPrint('🟢 Firebase Auth user created: ${user.uid}');

      // 🔐 Create Firestore profile
      await FirestoreService.instance.createUser(
        firebaseUser: user,
        username: username,
      );
      debugPrint('🟢 Firestore user created successfully');

      return user;
    } catch (e, s) {
      // VERY IMPORTANT: rollback auth if Firestore fails
      await _auth.currentUser?.delete();
      debugPrint('❌ Register failed: $e');
      debugPrint('STACKTRACE: $s');
      print('Register failed: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String getCurrentEmail() {
    return _auth.currentUser?.email ?? '';
  }

  String getCurrentName() {
    return _auth.currentUser?.displayName ?? '';
  }

  String getCurrentAvatar() {
    return _auth.currentUser?.photoURL ?? '';
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
