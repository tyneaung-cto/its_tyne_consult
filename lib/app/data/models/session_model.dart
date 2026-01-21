import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationSession {
  final String id;
  final String consultationId;
  final String userId;
  final int duration;
  final String meetingLink;
  final String status;
  final DateTime scheduledAt;

  ConsultationSession({
    required this.id,
    required this.consultationId,
    required this.userId,
    required this.duration,
    required this.meetingLink,
    required this.status,
    required this.scheduledAt,
  });

  factory ConsultationSession.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ConsultationSession(
      id: doc.id,
      consultationId: data['consultationId'],
      userId: data['userId'],
      duration: data['duration'],
      meetingLink: data['meetingLink'] ?? '',
      status: data['status'],
      scheduledAt: (data['scheduledAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'consultationId': consultationId,
      'userId': userId,
      'duration': duration,
      'meetingLink': meetingLink,
      'status': status,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
    };
  }
}
