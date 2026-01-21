import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/services/auth_service.dart';
import 'package:its_tyne_consult/app/core/services/firestore_service.dart';
import 'package:its_tyne_consult/app/routes/app_pages.dart';

class AuthGateController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<User?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();

    _authSubscription =
        _auth.authStateChanges().listen(_handleAuthState);
  }

  Future<void> _handleAuthState(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    try {
      final exists =
          await FirestoreService.instance.userExists(user.uid);

      if (exists) {
        Get.offAllNamed(Routes.HOME);
      } else {
        // User exists in Auth but not Firestore → rollback
        await _auth.signOut();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      // Safety fallback on Firestore failure
      await _auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
