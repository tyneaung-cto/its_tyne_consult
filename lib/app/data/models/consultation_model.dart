import 'package:cloud_firestore/cloud_firestore.dart';

class Consultation {
  final String id;
  final String userId;
  final String topic;
  final String timeSlot;
  final int duration;
  final String notes;
  final String status;
  final DateTime preferredDate;
  final DateTime createdAt;
  final String? actionBy;
  final DateTime? actionTime;

  Consultation({
    required this.id,
    required this.userId,
    required this.topic,
    required this.timeSlot,
    required this.duration,
    required this.notes,
    required this.status,
    required this.preferredDate,
    required this.createdAt,
    this.actionBy,
    this.actionTime,
  });

  factory Consultation.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Consultation(
      id: doc.id,
      userId: data['userID'],
      topic: data['topic'],
      timeSlot: data['timeSlot'],
      duration: data['duration'],
      notes: data['notes'],
      status: data['status'],
      preferredDate: (data['preferredDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      actionBy: data['actionBy'],
      actionTime: data['actionTime'] != null
          ? (data['actionTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userId,
      'topic': topic,
      'timeSlot': timeSlot,
      'duration': duration,
      'notes': notes,
      'status': status,
      'preferredDate': Timestamp.fromDate(preferredDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'actionBy': actionBy,
      'actionTime': actionTime != null ? Timestamp.fromDate(actionTime!) : null,
    };
  }
}
