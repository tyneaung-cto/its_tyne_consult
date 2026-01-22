import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String username;
  final String email;
  final String role;
  final bool isActive;
  final bool isBanned;
  final String profileImage;
  final DateTime createdAt;
  final bool requestDel;
  final DateTime? requestDelApplyDate;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
    required this.isBanned,
    required this.profileImage,
    required this.createdAt,
    required this.requestDel,
    this.requestDelApplyDate,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'client',
      isActive: data['isActive'] ?? true,
      isBanned: data['isBanned'] ?? false,
      profileImage: data['profile_image'] ?? '',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      requestDel: data['requestDel'] ?? false,
      requestDelApplyDate: data['requestDelApplyDate'] != null
          ? (data['requestDelApplyDate'] as Timestamp).toDate()
          : null,
    );
  }

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppUser.fromMap(doc.id, data);
  }
}
