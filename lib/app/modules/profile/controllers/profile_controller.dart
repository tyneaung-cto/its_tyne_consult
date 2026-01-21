import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/services/firestore_service.dart';
import 'package:its_tyne_consult/app/data/models/app_user_model.dart';
import '../../../core/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  /// Services
  final AuthService _authService = AuthService();

  /// User profile observables
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userRole = ''.obs;
  final RxnString profileImage = RxnString();
  final RxBool isUpdatingName = false.obs;
  final RxBool isUpdatingImage = false.obs;

  bool get hasProfileImage =>
      profileImage.value != null && profileImage.value!.isNotEmpty;

  /// Show dialog to edit user's full name
  void editUserNameDialog() {
    final textController = TextEditingController(text: userName.value);

    Get.defaultDialog(
      title: 'Edit Full Name',
      titleStyle: Get.textTheme.titleMedium,
      content: Column(
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
            ),
          ),
        ],
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () async {
        final newName = textController.text.trim();
        if (newName.isEmpty) return;

        await updateFullName(newName);
        Get.back();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  /// Load user profile data from Firestore
  Future<void> _loadUserProfile() async {
    try {
      debugPrint('🟡 Profile: loadUserProfile start');

      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        debugPrint('❌ Profile: FirebaseAuth currentUser is null');
        return;
      }

      debugPrint('🟢 Profile: Firebase UID = ${currentUser.uid}');

      final userSnapshot = await FirestoreService.instance.getCurrentUser();

      debugPrint('🟡 Profile: Firestore snapshot received');

      if (!userSnapshot.exists) {
        debugPrint('❌ Profile: user document does not exist');
        Get.snackbar(
          'Profile Error',
          'User profile not found.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final data = userSnapshot.data();
      if (data == null) {
        debugPrint('❌ Profile: snapshot data is null');
        return;
      }

      debugPrint('🟢 Profile: Firestore data = $data');

      final user = AppUser.fromMap(userSnapshot.id, data);

      userName.value = user.username;
      userEmail.value = user.email;
      userRole.value = user.role;
      if (user.profileImage.isNotEmpty) {
        profileImage.value = user.profileImage;
        debugPrint('🟢 Profile: profile image set -> ${profileImage.value}');
      } else {
        profileImage.value = null;
        debugPrint('⚠️ Profile: no profile image found');
      }

      debugPrint(
        '✅ Profile loaded & assigned: '
        'username=${userName.value}, '
        'email=${userEmail.value}, '
        'role=${userRole.value}',
      );
    } catch (e, s) {
      debugPrint('❌ Profile load error: $e');
      debugPrint('STACKTRACE: $s');
      Get.snackbar(
        'Profile Error',
        'Failed to load profile data.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateFullName(String newName) async {
    if (newName.trim().isEmpty) return;

    try {
      isUpdatingName.value = true;
      debugPrint('🟡 Profile: updateFullName start');

      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        debugPrint('❌ Profile: no auth user');
        return;
      }

      await FirestoreService.instance.updateUser(
        uid: currentUser.uid,
        data: {'username': newName.trim()},
      );

      userName.value = newName.trim();

      debugPrint('✅ Profile: full name updated -> ${userName.value}');
      Get.snackbar('Success', 'Full name updated');
    } catch (e, s) {
      debugPrint('❌ Profile: updateFullName error: $e');
      debugPrint('STACKTRACE: $s');
      Get.snackbar('Error', 'Failed to update full name');
    } finally {
      isUpdatingName.value = false;
    }
  }

  Future<void> pickAndUploadProfileImage() async {
    try {
      isUpdatingImage.value = true;
      debugPrint('🟡 Profile: pick image start');

      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        debugPrint('❌ Profile: no auth user');
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        debugPrint('⚠️ Profile: image picking cancelled');
        return;
      }

      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/${currentUser.uid}.jpg',
      );

      debugPrint('🟡 Profile: uploading image...');
      await ref.putFile(file);

      final downloadUrl = await ref.getDownloadURL();
      debugPrint('🟢 Profile: image uploaded -> $downloadUrl');

      await FirestoreService.instance.updateUser(
        uid: currentUser.uid,
        data: {'profile_image': downloadUrl},
      );

      profileImage.value = downloadUrl;
      debugPrint('✅ Profile: profileImage observable updated');

      Get.snackbar('Success', 'Profile image updated');
    } catch (e, s) {
      debugPrint('❌ Profile: image upload error: $e');
      debugPrint('STACKTRACE: $s');
      Get.snackbar('Error', 'Failed to update profile image');
    } finally {
      isUpdatingImage.value = false;
    }
  }

  /// Entry point from UI to change profile image
  /// (camera icon / edit avatar tap)
  Future<void> changeProfileImage() async {
    debugPrint('🟡 Profile: changeProfileImage triggered');

    // Prevent duplicate taps
    if (isUpdatingImage.value) {
      debugPrint('⚠️ Profile: image update already in progress');
      return;
    }

    await pickAndUploadProfileImage();
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
