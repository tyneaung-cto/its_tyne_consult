import 'dart:async';

import 'package:its_tyne_consult/app/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthGateController extends GetxController {
  final AuthService _authService = AuthService();

  /// Holds the current firebase user (null if logged out)
  final Rxn<User> firebaseUser = Rxn<User>();

  StreamSubscription<User?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    _authSubscription = _authService.userStream.listen(_onAuthStateChanged);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void _onAuthStateChanged(User? user) {
    firebaseUser.value = user;

    if (user == null) {
      // User is signed out -> go to login
      Get.offAllNamed('/login');
    } else {
      // User is signed in -> go to home
      Get.offAllNamed('/home');
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
