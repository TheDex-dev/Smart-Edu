import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final String? description;
  bool isCompleted;
  final DateTime? createdAt;
  final String? userId;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.description,
    this.isCompleted = false,
    this.createdAt,
    this.userId,
  });

  // Convert from Map (for JSON parsing and Firestore)
  factory Assignment.fromMap(Map<String, dynamic> map, [String? documentId]) {
    return Assignment(
      id:
          documentId ??
          map['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      dueDate: map['dueDate'] ?? '',
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt:
          map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : null,
      userId: map['userId'],
    );
  }

  // Convert from Firestore DocumentSnapshot
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Assignment.fromMap(data, doc.id);
  }

  // Convert to Map (for JSON serialization and Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'dueDate': dueDate,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt':
          createdAt != null
              ? Timestamp.fromDate(createdAt!)
              : FieldValue.serverTimestamp(),
      'userId': userId,
    };
  }

  // Create a copy with some fields changed
  Assignment copyWith({
    String? title,
    String? subject,
    String? dueDate,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
