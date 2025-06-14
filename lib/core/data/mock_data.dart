/// Centralized mock data for the Smart Edu application
/// This file contains all mock data used throughout the app for testing and development
/// Mock data class that provides sample data for the Smart Edu application
class MockData {
  MockData._();

  // =============================================================================
  // ASSIGNMENTS DATA
  // =============================================================================

  static final List<Map<String, dynamic>> assignments = [
    {
      'id': 'mock_1',
      'title': 'Software Engineering Project',
      'subject': 'Computer Science',
      'description':
          'Design and implement a full-stack web application using modern frameworks and best practices including responsive design, user authentication, and database integration',
      'dueDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'isCompleted': false,
      'priority': 'High',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 40,
      'attachments': [],
      'tags': ['programming', 'web-development', 'full-stack'],
    },
    {
      'id': 'mock_2',
      'title': 'Database Design Assignment',
      'subject': 'Database Systems',
      'description':
          'Design a normalized database schema for an e-commerce application with proper entity relationships, constraints, and optimization strategies',
      'dueDate': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'isCompleted': false,
      'priority': 'Medium',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 15,
      'attachments': [],
      'tags': ['database', 'sql', 'design'],
    },
    {
      'id': 'mock_3',
      'title': 'Algorithm Analysis Report',
      'subject': 'Algorithms',
      'description':
          'Analyze time and space complexity of various sorting algorithms including bubble sort, merge sort, quick sort, and heap sort',
      'dueDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'isCompleted': true,
      'priority': 'High',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 12,
      'attachments': [],
      'tags': ['algorithms', 'analysis', 'complexity'],
    },
    {
      'id': 'mock_4',
      'title': 'Data Structures Implementation',
      'subject': 'Data Structures',
      'description':
          'Implement and test various data structures including binary trees, hash tables, graphs, and their associated algorithms',
      'dueDate': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      'isCompleted': false,
      'priority': 'Medium',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 18)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 25,
      'attachments': [],
      'tags': ['data-structures', 'implementation', 'testing'],
    },
    {
      'id': 'mock_5',
      'title': 'Network Security Lab',
      'subject': 'Cybersecurity',
      'description':
          'Complete hands-on lab exercises on network penetration testing, vulnerability assessment, and security auditing using industry-standard tools',
      'dueDate': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'isCompleted': false,
      'priority': 'Medium',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 30,
      'attachments': [],
      'tags': ['security', 'networking', 'penetration-testing'],
    },
    {
      'id': 'mock_6',
      'title': 'Machine Learning Model Training',
      'subject': 'Machine Learning',
      'description':
          'Train and evaluate a neural network model for image classification using TensorFlow and compare different architectures',
      'dueDate': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
      'isCompleted': false,
      'priority': 'High',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 35,
      'attachments': [],
      'tags': ['machine-learning', 'tensorflow', 'neural-networks'],
    },
    {
      'id': 'mock_7',
      'title': 'Mobile App Development',
      'subject': 'Mobile Development',
      'description':
          'Develop a cross-platform mobile application using Flutter with features like user authentication, data persistence, and API integration',
      'dueDate': DateTime.now().add(const Duration(days: 21)).toIso8601String(),
      'isCompleted': false,
      'priority': 'High',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 50,
      'attachments': [],
      'tags': ['mobile-development', 'flutter', 'cross-platform'],
    },
    {
      'id': 'mock_8',
      'title': 'Web Application Security Assessment',
      'subject': 'Web Security',
      'description':
          'Conduct a comprehensive security assessment of a web application including OWASP Top 10 vulnerabilities testing',
      'dueDate': DateTime.now().add(const Duration(days: 12)).toIso8601String(),
      'isCompleted': false,
      'priority': 'High',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 28,
      'attachments': [],
      'tags': ['web-security', 'owasp', 'vulnerability-assessment'],
    },
  ];

  // Teacher-to-Student assignments for testing the new system
  static final List<Map<String, dynamic>> teacherAssignments = [
    {
      'id': 'teacher_assign_1',
      'title': 'React Components Workshop',
      'subject': 'Computer Science',
      'description': 'Build three different React components: a todo list, a weather widget, and a user profile card. Focus on proper state management and component lifecycle.',
      'dueDate': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'teacherId': 'mock_teacher_1',
      'teacherName': 'Dr. Sarah Johnson',
      'assignedTo': ['mock_student_1', 'mock_student_2', 'mock_student_3'],
      'className': '10th Grade',
      'points': 100,
    },
    {
      'id': 'teacher_assign_2',
      'title': 'Mathematical Functions Quiz',
      'subject': 'Mathematics',
      'description': 'Complete the quiz on quadratic functions, including graphing, finding roots, and solving word problems.',
      'dueDate': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      'teacherId': 'mock_teacher_2',
      'teacherName': 'Prof. Michael Chen',
      'assignedTo': ['mock_student_1', 'mock_student_4'],
      'className': '10th Grade',
      'points': 50,
    },
    {
      'id': 'teacher_assign_3',
      'title': 'Physics Lab Report',
      'subject': 'Physics',
      'description': 'Write a comprehensive lab report on the pendulum experiment, including hypothesis, methodology, results, and conclusion.',
      'dueDate': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'teacherId': 'mock_teacher_3',
      'teacherName': 'Dr. Emily Rodriguez',
      'assignedTo': ['mock_student_2', 'mock_student_3', 'mock_student_4', 'mock_student_5'],
      'className': '10th Grade',
      'points': 75,
    },
  ];

  // Sample student assignments (assigned by teachers)
  static final List<Map<String, dynamic>> studentAssignments = [
    {
      'id': 'student_assign_1',
      'title': 'Essay on Climate Change',
      'subject': 'Environmental Science',
      'description': 'Write a 1500-word essay discussing the causes, effects, and potential solutions to climate change.',
      'dueDate': DateTime.now().add(const Duration(days: 8)).toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'teacherId': 'mock_teacher_4',
      'teacherName': 'Dr. James Wilson',
      'assignedTo': ['mock_student_1'],
      'className': '10th Grade',
      'points': 80,
    },
    {
      'id': 'student_assign_2',
      'title': 'Spanish Vocabulary Test',
      'subject': 'Spanish',
      'description': 'Study chapters 5-7 vocabulary and complete the online assessment.',
      'dueDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'isCompleted': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'teacherId': 'mock_teacher_5',
      'teacherName': 'Señora Maria Lopez',
      'assignedTo': ['mock_student_1'],
      'className': '10th Grade',
      'points': 25,
    },
  ];

  // =============================================================================
  // USER PROFILE DATA
  // =============================================================================

  static final Map<String, dynamic> userProfile = {
    'uid': 'mock_user_123',
    'email': 'alex.johnson@smartedu.com',
    'displayName': 'Alex Johnson',
    'photoURL': null,
    'firstName': 'Alex',
    'lastName': 'Johnson',
    'studentId': 'SE2024001',
    'phoneNumber': '+1 (555) 123-4567',
    'address': {
      'street': '123 University Drive',
      'city': 'Academic City',
      'state': 'CA',
      'zipCode': '90210',
      'country': 'USA',
    },
    'dateOfBirth': DateTime(2002, 5, 15).toIso8601String(),
    'grade': 'Undergraduate Year 4',
    'major': 'Computer Science',
    'year': 'Senior',
    'gpa': 3.85,
    'semester': 'Fall 2024',
    'enrollmentDate': '2021-09-01',
    'expectedGraduation': '2025-05-15',
    'academicInfo': {
      'totalCourses': 32,
      'completedCourses': 28,
      'currentGPA': 3.85,
      'attendanceRate': 96.2,
      'totalCredits': 98,
      'creditsNeeded': 120,
      'currentCourses': 4,
      'averageGrade': 'A-',
      'academicStanding': 'Good Standing',
      'honorsProgram': true,
      'deansList': ['Spring 2022', 'Fall 2022', 'Spring 2023', 'Fall 2023'],
    },
    'courses': [
      {
        'courseId': 'CS401',
        'courseName': 'Advanced Software Engineering',
        'instructor': 'Dr. Sarah Wilson',
        'credits': 3,
        'grade': 'A-',
        'semester': 'Fall 2024',
      },
      {
        'courseId': 'CS420',
        'courseName': 'Machine Learning',
        'instructor': 'Prof. Michael Chen',
        'credits': 4,
        'grade': 'A',
        'semester': 'Fall 2024',
      },
      {
        'courseId': 'CS445',
        'courseName': 'Cybersecurity',
        'instructor': 'Dr. Rachel Davis',
        'credits': 3,
        'grade': 'B+',
        'semester': 'Fall 2024',
      },
      {
        'courseId': 'CS460',
        'courseName': 'Database Systems',
        'instructor': 'Prof. James Liu',
        'credits': 3,
        'grade': 'A-',
        'semester': 'Fall 2024',
      },
    ],
    'personalInfo': {
      'phone': '+1 (555) 123-4567',
      'address': {
        'street': '123 University Drive',
        'city': 'Academic City',
        'state': 'CA',
        'zipCode': '90210',
        'country': 'USA',
      },
      'emergencyContact': {
        'name': 'Dr. Robert Johnson',
        'relationship': 'Father',
        'phone': '+1 (555) 987-6543',
      },
    },
    'achievements': achievements,
    'statistics': {
      'assignmentsCompleted': 89,
      'assignmentsPending': 3,
      'averageScore': 92.5,
      'attendanceRate': 96.2,
      'studyHoursThisWeek': 28,
      'coursesThisSemester': 4,
      'upcomingDeadlines': 3,
      'totalAssignments': 92,
      'completedAssignments': 89,
      'pendingAssignments': 3,
    },
    'createdAt': '2021-09-01T08:00:00.000Z',
    'lastLogin': DateTime.now().toIso8601String(),
    'lastUpdated': DateTime.now().toIso8601String(),
  };

  // =============================================================================
  // ACADEMIC DATA
  // =============================================================================

  static final List<Map<String, String>> currentCourses = [
    {
      'name': 'Advanced Mathematics',
      'code': 'MATH-401',
      'credits': '4',
      'grade': 'A',
    },
    {
      'name': 'Physics',
      'code': 'PHYS-301',
      'credits': '4',
      'grade': 'A-'
    },
    {
      'name': 'Chemistry',
      'code': 'CHEM-301',
      'credits': '4',
      'grade': 'B+'
    },
    {
      'name': 'Biology',
      'code': 'BIO-301',
      'credits': '3',
      'grade': 'A'
    },
    {
      'name': 'English Literature',
      'code': 'ENG-301',
      'credits': '3',
      'grade': 'B+',
    },
    {
      'name': 'Computer Science',
      'code': 'CS-201',
      'credits': '3',
      'grade': 'A',
    },
  ];

  static final List<Map<String, String>> academicHistory = [
    {
      'year': '2023-2024',
      'grade': 'Grade 10',
      'gpa': '4.1',
      'credits': '30'
    },
    {
      'year': '2022-2023',
      'grade': 'Grade 9',
      'gpa': '3.9',
      'credits': '28'
    },
    {
      'year': '2021-2022',
      'grade': 'Grade 8',
      'gpa': '3.8',
      'credits': '26'
    },
  ];

  // =============================================================================
  // PERFORMANCE DATA
  // =============================================================================

  static final Map<String, String> performanceStats = {
    'overallGPA': '4.2',
    'attendance': '95%',
    'assignments': '18/20',
    'classRank': '#5',
  };

  static final List<Map<String, String>> recentPerformanceTests = [
    {
      'subject': 'Mathematics',
      'test': 'Final Exam',
      'score': '98%',
      'date': 'Dec 10',
    },
    {
      'subject': 'Physics',
      'test': 'Lab Report',
      'score': '94%',
      'date': 'Dec 8',
    },
    {
      'subject': 'Chemistry',
      'test': 'Midterm Exam',
      'score': '92%',
      'date': 'Dec 5',
    },
    {
      'subject': 'Biology',
      'test': 'Project',
      'score': '96%',
      'date': 'Dec 3',
    },
  ];

  static final List<Map<String, dynamic>> subjectStrengths = [
    {'name': 'Mathematics', 'strength': 98, 'color': 'blue'},
    {'name': 'Computer Science', 'strength': 96, 'color': 'green'},
    {'name': 'Biology', 'strength': 94, 'color': 'purple'},
    {'name': 'Physics', 'strength': 90, 'color': 'orange'},
    {'name': 'Chemistry', 'strength': 88, 'color': 'red'},
    {'name': 'English', 'strength': 85, 'color': 'teal'},
  ];

  // =============================================================================
  // ACHIEVEMENTS DATA
  // =============================================================================

  static final List<Map<String, dynamic>> achievements = [
    {
      'title': 'Dean\'s List',
      'description': 'Achieved Dean\'s List for academic excellence',
      'date': '2024-05-15',
      'type': 'academic',
      'icon': 'star',
      'color': 'gold',
    },
    {
      'title': 'Programming Contest Winner',
      'description': 'First place in Annual Coding Competition',
      'date': '2024-04-20',
      'type': 'competition',
      'icon': 'trophy',
      'color': 'orange',
    },
    {
      'title': 'Research Assistant',
      'description': 'Selected for AI Research Lab under Dr. Chen',
      'date': '2024-01-15',
      'type': 'research',
      'icon': 'science',
      'color': 'blue',
    },
    {
      'title': 'Perfect Attendance',
      'description': 'Maintained perfect attendance for the semester',
      'date': '2023-12-15',
      'type': 'attendance',
      'icon': 'calendar_today',
      'color': 'green',
    },
  ];

  // =============================================================================
  // SCHEDULE DATA
  // =============================================================================

  static final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static final Map<String, List<Map<String, dynamic>>> weeklySchedule = {
    'Monday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30',
        'room': 'A101',
        'teacher': 'Dr. Smith',
      },
      {
        'subject': 'Physics',
        'time': '09:45 - 11:15',
        'room': 'B203',
        'teacher': 'Prof. Johnson',
      },
      {
        'subject': 'Break',
        'time': '11:15 - 11:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Chemistry',
        'time': '11:30 - 13:00',
        'room': 'C105',
        'teacher': 'Dr. Williams',
      },
      {
        'subject': 'Lunch',
        'time': '13:00 - 14:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'English',
        'time': '14:00 - 15:30',
        'room': 'A205',
        'teacher': 'Ms. Brown',
      },
    ],
    'Tuesday': [
      {
        'subject': 'Biology',
        'time': '08:00 - 09:30',
        'room': 'D102',
        'teacher': 'Dr. Davis',
      },
      {
        'subject': 'Computer Science',
        'time': '09:45 - 11:15',
        'room': 'E301',
        'teacher': 'Mr. Wilson',
      },
      {
        'subject': 'Break',
        'time': '11:15 - 11:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Mathematics',
        'time': '11:30 - 13:00',
        'room': 'A101',
        'teacher': 'Dr. Smith',
      },
      {
        'subject': 'Lunch',
        'time': '13:00 - 14:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Art',
        'time': '14:00 - 15:30',
        'room': 'F201',
        'teacher': 'Ms. Garcia',
      },
    ],
    'Wednesday': [
      {
        'subject': 'Physics Lab',
        'time': '08:00 - 10:00',
        'room': 'B203L',
        'teacher': 'Prof. Johnson',
      },
      {
        'subject': 'Break',
        'time': '10:00 - 10:15',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'English',
        'time': '10:15 - 11:45',
        'room': 'A205',
        'teacher': 'Ms. Brown',
      },
      {
        'subject': 'Break',
        'time': '11:45 - 12:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Chemistry',
        'time': '12:00 - 13:30',
        'room': 'C105',
        'teacher': 'Dr. Williams',
      },
      {
        'subject': 'Lunch',
        'time': '13:30 - 14:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'PE',
        'time': '14:30 - 16:00',
        'room': 'Gym',
        'teacher': 'Coach Miller',
      },
    ],
    'Thursday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30',
        'room': 'A101',
        'teacher': 'Dr. Smith',
      },
      {
        'subject': 'Biology Lab',
        'time': '09:45 - 11:45',
        'room': 'D102L',
        'teacher': 'Dr. Davis',
      },
      {
        'subject': 'Break',
        'time': '11:45 - 12:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Computer Science',
        'time': '12:00 - 13:30',
        'room': 'E301',
        'teacher': 'Mr. Wilson',
      },
      {
        'subject': 'Lunch',
        'time': '13:30 - 14:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'History',
        'time': '14:30 - 16:00',
        'room': 'G102',
        'teacher': 'Mr. Taylor',
      },
    ],
    'Friday': [
      {
        'subject': 'Chemistry Lab',
        'time': '08:00 - 10:00',
        'room': 'C105L',
        'teacher': 'Dr. Williams',
      },
      {
        'subject': 'Break',
        'time': '10:00 - 10:15',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Physics',
        'time': '10:15 - 11:45',
        'room': 'B203',
        'teacher': 'Prof. Johnson',
      },
      {
        'subject': 'Break',
        'time': '11:45 - 12:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Biology',
        'time': '12:00 - 13:30',
        'room': 'D102',
        'teacher': 'Dr. Davis',
      },
      {
        'subject': 'Lunch',
        'time': '13:30 - 14:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Study Hall',
        'time': '14:30 - 15:30',
        'room': 'Library',
        'teacher': '',
      },
    ],
  };

  // =============================================================================
  // OPTIONS AND CONFIGURATIONS
  // =============================================================================

  static final List<String> grades = [
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
    'Undergraduate Year 1',
    'Undergraduate Year 2',
    'Undergraduate Year 3',
    'Undergraduate Year 4',
    'Graduate Student',
    'PhD Student',
  ];

  static final List<String> majors = [
    'Science',
    'Mathematics',
    'Computer Science',
    'Engineering',
    'Literature',
    'History',
    'Business',
    'Arts',
    'Music',
    'Sports',
    'Medicine',
    'Other',
  ];

  static final List<String> subjects = [
    'Mathematics',
    'Science',
    'History',
    'Literature',
    'Computer Science',
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',
    'Art',
    'Music',
    'Physical Education',
    'Other',
  ];

  static final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];

  static final List<String> assignmentFilters = [
    'All',
    'Completed',
    'Pending',
    'Due Today',
    'Overdue',
  ];

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Get all mock data as a single map for easy access
  static Map<String, dynamic> getAllData() {
    return {
      'assignments': assignments,
      'userProfile': userProfile,
      'currentCourses': currentCourses,
      'academicHistory': academicHistory,
      'performanceStats': performanceStats,
      'recentPerformanceTests': recentPerformanceTests,
      'subjectStrengths': subjectStrengths,
      'achievements': achievements,
      'weekDays': weekDays,
      'weeklySchedule': weeklySchedule,
      'grades': grades,
      'majors': majors,
      'subjects': subjects,
      'languages': languages,
      'assignmentFilters': assignmentFilters,
    };
  }

  /// Reset all data to initial values (useful for testing)
  static void resetData() {
    // Since all data is static final, it cannot be reset
    // This method is here for future extensibility if needed
  }

  /// Get academic summary information
  static Map<String, dynamic> getAcademicSummary() {
    return {
      'studentId': userProfile['studentId'],
      'academicYear': '2024-2025',
      'semester': 'Fall 2024',
      'creditsEarned': '45/60',
      'currentGPA': '4.2',
      'classRank': '5/120',
      'grade': 'Grade 10 • Science Major',
    };
  }

  /// Get statistics for academic performance
  static Map<String, dynamic> getAcademicStats() {
    return {
      'currentGPA': 4.2,
      'attendanceRate': 95.0,
      'totalCourses': currentCourses.length,
      'completedCourses': 28,
      'totalCredits': 98,
      'totalAssignments': assignments.length,
      'completedAssignments': assignments.where((a) => a['isCompleted'] == true).length,
      'pendingAssignments': assignments.where((a) => a['isCompleted'] == false).length,
    };
  }

  /// Get user profile data for easy access
  static Map<String, dynamic> getUserData() {
    return userProfile;
  }

  /// Get assignments data
  static List<Map<String, dynamic>> getAssignments() {
    return assignments;
  }

  /// Get completed assignments
  static List<Map<String, dynamic>> getCompletedAssignments() {
    return assignments.where((a) => a['isCompleted'] == true).toList();
  }

  /// Get pending assignments
  static List<Map<String, dynamic>> getPendingAssignments() {
    return assignments.where((a) => a['isCompleted'] == false).toList();
  }

  /// Get assignments due today
  static List<Map<String, dynamic>> getAssignmentsDueToday() {
    final today = DateTime.now();
    return assignments.where((a) {
      try {
        final dueDate = DateTime.parse(a['dueDate']);
        return dueDate.year == today.year &&
            dueDate.month == today.month &&
            dueDate.day == today.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Get overdue assignments
  static List<Map<String, dynamic>> getOverdueAssignments() {
    final today = DateTime.now();
    return assignments.where((a) {
      if (a['isCompleted'] == true) return false;
      try {
        final dueDate = DateTime.parse(a['dueDate']);
        return dueDate.isBefore(today);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Get schedule for a specific day
  static List<Map<String, dynamic>> getScheduleForDay(String day) {
    return weeklySchedule[day] ?? [];
  }

  /// Get current day's schedule
  static List<Map<String, dynamic>> getTodaySchedule() {
    final today = DateTime.now();
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final dayName = dayNames[today.weekday - 1];
    return getScheduleForDay(dayName);
  }

  /// Get user achievements filtered by type
  static List<Map<String, dynamic>> getAchievementsByType(String type) {
    return achievements.where((a) => a['type'] == type).toList();
  }

  /// Get performance data for charts and analytics
  static Map<String, dynamic> getPerformanceData() {
    return {
      'stats': performanceStats,
      'recentTests': recentPerformanceTests,
      'subjectStrengths': subjectStrengths,
    };
  }

  // =============================================================================
  // USER PROFILE CREATION METHODS
  // =============================================================================

  /// Create initial user profile for a new student account
  static Map<String, dynamic> createStudentProfile({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    String? displayName,
    String? photoURL,
    String? major,
    String? grade,
    String? phoneNumber,
  }) {
    final now = DateTime.now();
    final currentYear = now.year;
    
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName ?? '$firstName $lastName',
      'photoURL': photoURL,
      'firstName': firstName,
      'lastName': lastName,
      'userType': 'student',
      'studentId': 'ST$currentYear${uid.substring(0, 6).toUpperCase()}',
      'phoneNumber': phoneNumber,
      'address': {
        'street': '',
        'city': '',
        'state': '',
        'zipCode': '',
        'country': 'USA',
      },
      'dateOfBirth': null,
      'grade': grade ?? 'Freshman',
      'major': major ?? 'Undeclared',
      'year': grade ?? 'Freshman',
      'gpa': 0.0,
      'semester': 'Fall $currentYear',
      'enrollmentDate': now.toIso8601String().split('T')[0],
      'expectedGraduation': null,
      'isActive': true,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'academicInfo': {
        'totalCourses': 0,
        'completedCourses': 0,
        'currentGPA': 0.0,
        'attendanceRate': 100.0,
        'totalCredits': 0,
        'creditsNeeded': 120,
        'currentCourses': 0,
        'averageGrade': 'N/A',
        'academicStanding': 'Good Standing',
        'honorsProgram': false,
        'deansList': [],
      },
      'courses': [],
      'preferences': {
        'notifications': {
          'assignments': true,
          'grades': true,
          'schedule': true,
          'announcements': true,
        },
        'theme': 'system',
        'language': 'en',
        'timezone': 'America/New_York',
      },
      'emergencyContact': {
        'name': '',
        'relationship': '',
        'phoneNumber': '',
        'email': '',
      },
    };
  }

  /// Create initial user profile for a new teacher/professor account
  static Map<String, dynamic> createTeacherProfile({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    String? displayName,
    String? photoURL,
    String? department,
    String? title,
    String? phoneNumber,
    String? officeLocation,
  }) {
    final now = DateTime.now();
    final currentYear = now.year;
    
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName ?? '$firstName $lastName',
      'photoURL': photoURL,
      'firstName': firstName,
      'lastName': lastName,
      'userType': 'teacher',
      'employeeId': 'FAC$currentYear${uid.substring(0, 6).toUpperCase()}',
      'phoneNumber': phoneNumber,
      'officeLocation': officeLocation,
      'address': {
        'street': '',
        'city': '',
        'state': '',
        'zipCode': '',
        'country': 'USA',
      },
      'dateOfBirth': null,
      'department': department ?? 'General Studies',
      'title': title ?? 'Assistant Professor',
      'hireDate': now.toIso8601String().split('T')[0],
      'tenure': false,
      'isActive': true,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'academicInfo': {
        'totalCourses': 0,
        'currentCourses': 0,
        'totalStudents': 0,
        'averageRating': 0.0,
        'yearsOfExperience': 0,
        'researchInterests': [],
        'publications': [],
        'degrees': [],
      },
      'courses': [],
      'schedule': {
        'officeHours': [],
        'classes': [],
      },
      'preferences': {
        'notifications': {
          'assignments': true,
          'grades': true,
          'schedule': true,
          'announcements': true,
          'studentMessages': true,
        },
        'theme': 'system',
        'language': 'en',
        'timezone': 'America/New_York',
      },
      'contactInfo': {
        'officePhone': phoneNumber,
        'personalPhone': '',
        'officeLocation': officeLocation ?? 'TBD',
        'mailbox': '',
      },
    };
  }

  /// Creates initial assignments for a new student
  static List<Map<String, dynamic>> createInitialStudentAssignments(String userId) {
    return [
      {
        'id': 'welcome_${userId}_1',
        'title': 'Welcome to Smart Edu',
        'subject': 'Orientation',
        'description': 'Complete your profile setup and explore the Smart Edu features. This is your first assignment to help you get familiar with the platform.',
        'dueDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'isCompleted': false,
        'priority': 'Low',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': userId,
        'estimatedHours': 1,
        'attachments': [],
        'tags': ['orientation', 'welcome'],
      },
      {
        'id': 'setup_${userId}_2',
        'title': 'Set Up Study Schedule',
        'subject': 'Planning',
        'description': 'Create your weekly study schedule using the Schedule feature. Plan your study times for maximum productivity.',
        'dueDate': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
        'isCompleted': false,
        'priority': 'Medium',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': userId,
        'estimatedHours': 2,
        'attachments': [],
        'tags': ['planning', 'schedule'],
      },
    ];
  }

  /// Creates initial assignments for a new teacher
  static List<Map<String, dynamic>> createInitialTeacherAssignments(String userId) {
    return [
      {
        'id': 'teacher_welcome_${userId}_1',
        'title': 'Teacher Orientation',
        'subject': 'Orientation',
        'description': 'Welcome to Smart Edu! Complete your teacher profile and explore the educator features available on the platform.',
        'dueDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'isCompleted': false,
        'priority': 'High',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': userId,
        'estimatedHours': 2,
        'attachments': [],
        'tags': ['orientation', 'teacher', 'setup'],
      },
      {
        'id': 'class_setup_${userId}_2',
        'title': 'Set Up Your First Class',
        'subject': 'Class Management',
        'description': 'Create your first class and explore the assignment management tools available for educators.',
        'dueDate': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
        'isCompleted': false,
        'priority': 'Medium',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': userId,
        'estimatedHours': 3,
        'attachments': [],
        'tags': ['class-setup', 'management'],
      },
    ];
  }

  /// Creates a complete user data package for new signups
  static Map<String, dynamic> createUserDataPackage({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String userType,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? department,
    String? title,
    String? major,
    String? grade,
    String? officeLocation,
  }) {
    final isTeacher = userType.toLowerCase() == 'teacher' || userType.toLowerCase() == 'professor';
    
    final profile = isTeacher 
        ? createTeacherProfile(
            uid: uid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            displayName: displayName,
            photoURL: photoURL,
            department: department,
            title: title,
            phoneNumber: phoneNumber,
            officeLocation: officeLocation,
          )
        : createStudentProfile(
            uid: uid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            displayName: displayName,
            photoURL: photoURL,
            major: major,
            grade: grade,
            phoneNumber: phoneNumber,
          );
    
    final assignments = isTeacher
        ? createInitialTeacherAssignments(uid)
        : createInitialStudentAssignments(uid);
    
    final academicStats = getInitialAcademicStats(userType);

    return {
      'profile': profile,
      'assignments': assignments,
      'academicStats': academicStats,
      'userType': userType,
    };
  }

  static Map<String, dynamic> getInitialAcademicStats(String userType) {
    if (userType.toLowerCase() == 'teacher' || userType.toLowerCase() == 'professor') {
      return {
        'totalCourses': 0,
        'currentCourses': 0,
        'totalStudents': 0,
        'averageRating': 0.0,
        'yearsOfExperience': 0,
        'completedAssignments': 0,
        'pendingAssignments': 0,
      };
    } else {
      return {
        'currentGPA': 0.0,
        'attendanceRate': 100.0,
        'totalCourses': 0,
        'completedCourses': 0,
        'totalCredits': 0,
        'totalAssignments': 0,
        'completedAssignments': 0,
        'pendingAssignments': 0,
      };
    }
  }
}
