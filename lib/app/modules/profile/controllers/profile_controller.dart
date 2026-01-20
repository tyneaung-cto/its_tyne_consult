import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';

class ProfileController extends GetxController {
  /// Services
  final AuthService _authService = AuthService();

  /// User profile data (for now mocked, later from Firestore)
  final RxString _userName = 'ItsTyne User'.obs;
  final RxString _userEmail = 'user@itstyne.com'.obs;
  final RxString _userRole = 'Client'.obs;

  /// Public getters (used by ProfileView)
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;
  String get userRole => _userRole.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  /// Load user profile data
  /// Later this should fetch from Firestore
  void _loadUserProfile() {
    final currentUser = _authService.getCurrentUser();

    if (currentUser != null) {
      _userEmail.value = currentUser.email ?? '';
      _userName.value = currentUser.displayName ?? _userName.value;
    }
  }

  /// Navigate to edit profile screen
  void editProfile() {
    // TODO: Implement edit profile navigation
    // Get.toNamed('/edit-profile');
  }

  /// Trigger change password flow
  void changePassword() {
    // TODO: Implement password reset flow
    // _authService.sendPasswordResetEmail(_userEmail.value);
    Get.snackbar(
      'Change Password',
      'Password change instructions will be sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
