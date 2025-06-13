import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? grade;
  final String? major;
  final String? studentId;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? address;
  final Map<String, dynamic>? academicInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.grade,
    this.major,
    this.studentId,
    this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.academicInfo,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from Map (for JSON parsing and Firestore)
  factory UserProfile.fromMap(Map<String, dynamic> map, [String? documentId]) {
    return UserProfile(
      id: documentId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      grade: map['grade'],
      major: map['major'],
      studentId: map['studentId'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: map['dateOfBirth'] is Timestamp
          ? (map['dateOfBirth'] as Timestamp).toDate()
          : map['dateOfBirth'] != null
              ? DateTime.parse(map['dateOfBirth'])
              : null,
      address: map['address'],
      academicInfo: map['academicInfo'] is Map<String, dynamic>
          ? map['academicInfo']
          : null,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'] != null
              ? DateTime.parse(map['updatedAt'])
              : null,
    );
  }

  // Convert from Firestore DocumentSnapshot
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile.fromMap(data, doc.id);
  }

  // Convert to Map (for JSON serialization and Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'grade': grade,
      'major': major,
      'studentId': studentId,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'address': address,
      'academicInfo': academicInfo,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create a copy with some fields changed
  UserProfile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? grade,
    String? major,
    String? studentId,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? address,
    Map<String, dynamic>? academicInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      grade: grade ?? this.grade,
      major: major ?? this.major,
      studentId: studentId ?? this.studentId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      academicInfo: academicInfo ?? this.academicInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get academic progress stats
  Map<String, dynamic> getAcademicStats() {
    if (academicInfo == null) {
      return {
        'totalCourses': 0,
        'completedCourses': 0,
        'currentGPA': 0.0,
        'attendanceRate': 0.0,
        'totalCredits': 0,
      };
    }

    return {
      'totalCourses': academicInfo!['totalCourses'] ?? 0,
      'completedCourses': academicInfo!['completedCourses'] ?? 0,
      'currentGPA': (academicInfo!['currentGPA'] ?? 0.0).toDouble(),
      'attendanceRate': (academicInfo!['attendanceRate'] ?? 0.0).toDouble(),
      'totalCredits': academicInfo!['totalCredits'] ?? 0,
    };
  }

  // Get formatted display name
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  // Get formatted grade and major
  String get academicLevel {
    if (grade != null && major != null) {
      return '$grade • $major';
    } else if (grade != null) {
      return grade!;
    } else if (major != null) {
      return major!;
    }
    return 'Not specified';
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, grade: $grade, major: $major)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
