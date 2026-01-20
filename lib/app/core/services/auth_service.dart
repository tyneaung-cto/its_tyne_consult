import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get userStream => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error in signInWithEmailAndPassword: $e');
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error in registerWithEmailAndPassword: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String getCurrentEmail() {
    return _auth.currentUser?.email ?? '';
  }
  String getCurrentName(){
    return _auth.currentUser?.displayName ?? '';
  }
  String getCurrentAvatar(){
    return _auth.currentUser?.photoURL ?? '';
  }

  User? getCurrentUser(){
    return _auth.currentUser;
  }


}
