import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettings {
  final String id;
  final String userId;
  
  // Personal Information
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? bio;
  final String? photoUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final String? alternateEmail;
  
  // Address Information
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  
  // Academic Information
  final String? role; // 'student', 'teacher', 'professor', 'admin'
  final String? institutionName;
  final String? department;
  final String? grade;
  final String? major;
  final String? studentId;
  final String? teacherId;
  final String? yearOfStudy;
  final List<String>? subjects;
  final List<String>? specializations;
  
  // Professional Information (for teachers)
  final String? qualification;
  final int? yearsOfExperience;
  final List<String>? certifications;
  final String? officeLocation;
  final String? officeHours;
  
  // Privacy Settings
  final bool showEmail;
  final bool showPhoneNumber;
  final bool showAddress;
  final bool allowDirectMessages;
  final bool showOnlineStatus;
  
  // Notification Preferences
  final bool emailNotifications;
  final bool pushNotifications;
  final bool assignmentReminders;
  final bool gradeNotifications;
  final bool announcementNotifications;
  
  // Theme and Display Preferences
  final String? preferredLanguage;
  final String? timeZone;
  final String? dateFormat;
  final String? theme; // 'light', 'dark', 'auto'
  
  // Social Links
  final Map<String, String>? socialLinks;
  
  // Emergency Contact
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isProfileComplete;

  ProfileSettings({
    required this.id,
    required this.userId,
    this.firstName,
    this.lastName,
    this.displayName,
    this.bio,
    this.photoUrl,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.alternateEmail,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.role,
    this.institutionName,
    this.department,
    this.grade,
    this.major,
    this.studentId,
    this.teacherId,
    this.yearOfStudy,
    this.subjects,
    this.specializations,
    this.qualification,
    this.yearsOfExperience,
    this.certifications,
    this.officeLocation,
    this.officeHours,
    this.showEmail = true,
    this.showPhoneNumber = false,
    this.showAddress = false,
    this.allowDirectMessages = true,
    this.showOnlineStatus = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.assignmentReminders = true,
    this.gradeNotifications = true,
    this.announcementNotifications = true,
    this.preferredLanguage,
    this.timeZone,
    this.dateFormat,
    this.theme,
    this.socialLinks,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.createdAt,
    this.updatedAt,
    this.isProfileComplete = false,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? firstName ?? lastName ?? 'User';
  }

  // Convert from Map (for JSON parsing and Firestore)
  factory ProfileSettings.fromMap(Map<String, dynamic> map, [String? documentId]) {
    return ProfileSettings(
      id: documentId ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'],
      lastName: map['lastName'],
      displayName: map['displayName'],
      bio: map['bio'],
      photoUrl: map['photoUrl'],
      dateOfBirth: map['dateOfBirth'] is Timestamp
          ? (map['dateOfBirth'] as Timestamp).toDate()
          : map['dateOfBirth'] != null
              ? DateTime.parse(map['dateOfBirth'])
              : null,
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      alternateEmail: map['alternateEmail'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      postalCode: map['postalCode'],
      role: map['role'],
      institutionName: map['institutionName'],
      department: map['department'],
      grade: map['grade'],
      major: map['major'],
      studentId: map['studentId'],
      teacherId: map['teacherId'],
      yearOfStudy: map['yearOfStudy'],
      subjects: map['subjects'] != null ? List<String>.from(map['subjects']) : null,
      specializations: map['specializations'] != null ? List<String>.from(map['specializations']) : null,
      qualification: map['qualification'],
      yearsOfExperience: map['yearsOfExperience'],
      certifications: map['certifications'] != null ? List<String>.from(map['certifications']) : null,
      officeLocation: map['officeLocation'],
      officeHours: map['officeHours'],
      showEmail: map['showEmail'] ?? true,
      showPhoneNumber: map['showPhoneNumber'] ?? false,
      showAddress: map['showAddress'] ?? false,
      allowDirectMessages: map['allowDirectMessages'] ?? true,
      showOnlineStatus: map['showOnlineStatus'] ?? true,
      emailNotifications: map['emailNotifications'] ?? true,
      pushNotifications: map['pushNotifications'] ?? true,
      assignmentReminders: map['assignmentReminders'] ?? true,
      gradeNotifications: map['gradeNotifications'] ?? true,
      announcementNotifications: map['announcementNotifications'] ?? true,
      preferredLanguage: map['preferredLanguage'],
      timeZone: map['timeZone'],
      dateFormat: map['dateFormat'],
      theme: map['theme'],
      socialLinks: map['socialLinks'] is Map<String, dynamic>
          ? Map<String, String>.from(map['socialLinks'])
          : null,
      emergencyContactName: map['emergencyContactName'],
      emergencyContactPhone: map['emergencyContactPhone'],
      emergencyContactRelation: map['emergencyContactRelation'],
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
      isProfileComplete: map['isProfileComplete'] ?? false,
    );
  }

  // Convert from Firestore DocumentSnapshot
  factory ProfileSettings.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProfileSettings.fromMap(data, doc.id);
  }

  // Convert to Map (for JSON serialization and Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'bio': bio,
      'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'alternateEmail': alternateEmail,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'role': role,
      'institutionName': institutionName,
      'department': department,
      'grade': grade,
      'major': major,
      'studentId': studentId,
      'teacherId': teacherId,
      'yearOfStudy': yearOfStudy,
      'subjects': subjects,
      'specializations': specializations,
      'qualification': qualification,
      'yearsOfExperience': yearsOfExperience,
      'certifications': certifications,
      'officeLocation': officeLocation,
      'officeHours': officeHours,
      'showEmail': showEmail,
      'showPhoneNumber': showPhoneNumber,
      'showAddress': showAddress,
      'allowDirectMessages': allowDirectMessages,
      'showOnlineStatus': showOnlineStatus,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'assignmentReminders': assignmentReminders,
      'gradeNotifications': gradeNotifications,
      'announcementNotifications': announcementNotifications,
      'preferredLanguage': preferredLanguage,
      'timeZone': timeZone,
      'dateFormat': dateFormat,
      'theme': theme,
      'socialLinks': socialLinks,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactRelation': emergencyContactRelation,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isProfileComplete': isProfileComplete,
    };
  }

  // Create a copy with some fields changed
  ProfileSettings copyWith({
    String? firstName,
    String? lastName,
    String? displayName,
    String? bio,
    String? photoUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? alternateEmail,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? role,
    String? institutionName,
    String? department,
    String? grade,
    String? major,
    String? studentId,
    String? teacherId,
    String? yearOfStudy,
    List<String>? subjects,
    List<String>? specializations,
    String? qualification,
    int? yearsOfExperience,
    List<String>? certifications,
    String? officeLocation,
    String? officeHours,
    bool? showEmail,
    bool? showPhoneNumber,
    bool? showAddress,
    bool? allowDirectMessages,
    bool? showOnlineStatus,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? assignmentReminders,
    bool? gradeNotifications,
    bool? announcementNotifications,
    String? preferredLanguage,
    String? timeZone,
    String? dateFormat,
    String? theme,
    Map<String, String>? socialLinks,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isProfileComplete,
  }) {
    return ProfileSettings(
      id: id,
      userId: userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      alternateEmail: alternateEmail ?? this.alternateEmail,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      role: role ?? this.role,
      institutionName: institutionName ?? this.institutionName,
      department: department ?? this.department,
      grade: grade ?? this.grade,
      major: major ?? this.major,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      subjects: subjects ?? this.subjects,
      specializations: specializations ?? this.specializations,
      qualification: qualification ?? this.qualification,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      certifications: certifications ?? this.certifications,
      officeLocation: officeLocation ?? this.officeLocation,
      officeHours: officeHours ?? this.officeHours,
      showEmail: showEmail ?? this.showEmail,
      showPhoneNumber: showPhoneNumber ?? this.showPhoneNumber,
      showAddress: showAddress ?? this.showAddress,
      allowDirectMessages: allowDirectMessages ?? this.allowDirectMessages,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      assignmentReminders: assignmentReminders ?? this.assignmentReminders,
      gradeNotifications: gradeNotifications ?? this.gradeNotifications,
      announcementNotifications: announcementNotifications ?? this.announcementNotifications,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      theme: theme ?? this.theme,
      socialLinks: socialLinks ?? this.socialLinks,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation ?? this.emergencyContactRelation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  // Check if profile has required fields completed
  bool get hasRequiredFields {
    return firstName != null && 
           lastName != null && 
           role != null && 
           phoneNumber != null;
  }

  // Calculate profile completion percentage
  double get completionPercentage {
    int totalFields = 0;
    int completedFields = 0;

    // Required fields
    final requiredFields = [firstName, lastName, role, phoneNumber];
    totalFields += requiredFields.length;
    completedFields += requiredFields.where((field) => field != null && field.isNotEmpty).length;

    // Optional but important fields
    final optionalFields = [bio, dateOfBirth, address, institutionName, department];
    totalFields += optionalFields.length;
    completedFields += optionalFields.where((field) => field != null && field.toString().isNotEmpty).length;

    return totalFields > 0 ? (completedFields / totalFields) : 0.0;
  }
}
