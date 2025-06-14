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
  final String? teacherId; // ID of the teacher who created the assignment
  final List<String>? assignedTo; // List of student IDs this assignment is assigned to
  final String? teacherName; // Name of the teacher for display
  final String? className; // Class or grade this assignment is for
  final int? points; // Points or marks for the assignment

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.description,
    this.isCompleted = false,
    this.createdAt,
    this.userId,
    this.teacherId,
    this.assignedTo,
    this.teacherName,
    this.className,
    this.points,
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
      teacherId: map['teacherId'],
      assignedTo: map['assignedTo'] != null 
          ? List<String>.from(map['assignedTo'])
          : null,
      teacherName: map['teacherName'],
      className: map['className'],
      points: map['points'],
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
      'teacherId': teacherId,
      'assignedTo': assignedTo,
      'teacherName': teacherName,
      'className': className,
      'points': points,
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
    String? teacherId,
    List<String>? assignedTo,
    String? teacherName,
    String? className,
    int? points,
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
      teacherId: teacherId ?? this.teacherId,
      assignedTo: assignedTo ?? this.assignedTo,
      teacherName: teacherName ?? this.teacherName,
      className: className ?? this.className,
      points: points ?? this.points,
    );
  }
}
