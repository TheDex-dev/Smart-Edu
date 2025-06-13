import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../firebase_options.dart';
import '../utils/cache_manager.dart';
import '../utils/error_utils.dart';
import '../models/assignment.dart';
import '../models/user_profile.dart';

class FirebaseService {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebaseMessaging? _messaging;
  static FirebasePerformance? _performance;
  static FirebaseStorage? _storage;
  static GoogleSignIn? _googleSignIn;
  static final CacheManager _cache = CacheManager.instance;

  // Platform detection
  static bool get _isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  static bool get isFirebaseSupported => !_isDesktop;

  // Mock data for desktop platforms
  static final List<Map<String, dynamic>> _mockAssignments = [
    {
      'id': 'mock_1',
      'title': 'Flutter Development Project',
      'subject': 'Computer Science',
      'description':
          'Build a comprehensive Flutter application with Firebase integration, including user authentication, database operations, and cloud storage',
      'dueDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'isCompleted': false,
      'priority': 'High',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 40,
      'attachments': [],
      'tags': ['programming', 'mobile-dev', 'flutter'],
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
      'estimatedHours': 20,
      'attachments': ['algorithm_analysis.pdf'],
      'tags': ['algorithms', 'complexity', 'analysis'],
    },
    {
      'id': 'mock_4',
      'title': 'UI/UX Research Paper',
      'subject': 'Human-Computer Interaction',
      'description':
          'Research modern UI/UX trends and write a comprehensive analysis covering user experience principles, accessibility, and responsive design',
      'dueDate': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      'isCompleted': false,
      'priority': 'Low',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 25,
      'attachments': [],
      'tags': ['ui', 'ux', 'research', 'design'],
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
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 35,
      'attachments': [],
      'tags': ['ml', 'ai', 'tensorflow', 'neural-networks'],
    },
    {
      'id': 'mock_7',
      'title': 'Data Structures Implementation',
      'subject': 'Data Structures',
      'description':
          'Implement various data structures (stack, queue, linked list, binary tree) in Python with comprehensive unit tests',
      'dueDate': DateTime.now().add(const Duration(days: 6)).toIso8601String(),
      'isCompleted': true,
      'priority': 'Medium',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      'userId': 'mock_user_123',
      'estimatedHours': 18,
      'attachments': ['data_structures.py', 'tests.py'],
      'tags': ['data-structures', 'python', 'programming'],
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

  static final Map<String, dynamic> _mockUser = {
    'uid': 'mock_user_123',
    'email': 'alex.johnson@smartedu.com',
    'displayName': 'Alex Johnson',
    'photoURL': null,
    'firstName': 'Alex',
    'lastName': 'Johnson',
    'studentId': 'SE2024001',
    'major': 'Computer Science',
    'year': 'Senior',
    'gpa': 3.85,
    'semester': 'Fall 2024',
    'enrollmentDate': '2021-09-01',
    'expectedGraduation': '2025-05-15',
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
    'academicProgress': {
      'totalCredits': 98,
      'creditsNeeded': 120,
      'completedCourses': 32,
      'currentCourses': 4,
      'averageGrade': 'A-',
      'academicStanding': 'Good Standing',
      'honorsProgram': true,
      'deansList': ['Spring 2022', 'Fall 2022', 'Spring 2023', 'Fall 2023'],
    },
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
        'name': 'Maria Johnson',
        'relationship': 'Mother',
        'phone': '+1 (555) 987-6543',
      },
      'dateOfBirth': '2002-03-15',
      'nationality': 'American',
    },
    'preferences': {
      'theme': 'light',
      'notifications': {
        'assignmentReminders': true,
        'gradeUpdates': true,
        'scheduleChanges': true,
        'emailNotifications': true,
        'pushNotifications': true,
      },
      'language': 'English',
      'timezone': 'America/Los_Angeles',
    },
    'achievements': [
      {
        'title': 'Academic Excellence Award',
        'description': 'Maintained GPA above 3.8 for 4 consecutive semesters',
        'date': '2024-05-15',
        'type': 'academic',
      },
      {
        'title': 'Hackathon Winner',
        'description': 'First place in University Code Challenge 2024',
        'date': '2024-04-20',
        'type': 'competition',
      },
      {
        'title': 'Research Assistant',
        'description': 'Selected for AI Research Lab under Dr. Chen',
        'date': '2024-01-15',
        'type': 'research',
      },
    ],
    'statistics': {
      'assignmentsCompleted': 89,
      'assignmentsPending': 3,
      'averageScore': 92.5,
      'attendanceRate': 96.2,
      'studyHoursThisWeek': 28,
      'coursesThisSemester': 4,
      'upcomingDeadlines': 3,
    },
    'createdAt': '2021-09-01T08:00:00.000Z',
    'lastLogin': DateTime.now().toIso8601String(),
    'lastUpdated': DateTime.now().toIso8601String(),
  };

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      if (_isDesktop) {
        debugPrint(
          'Running on desktop platform - Using mock data instead of Firebase',
        );
        await _cache.initialize();
        return;
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize Firebase services
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _messaging = FirebaseMessaging.instance;
      _performance = FirebasePerformance.instance;
      _storage = FirebaseStorage.instance;
      _googleSignIn = GoogleSignIn();

      // Initialize Crashlytics
      await _crashlytics!.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = (FlutterErrorDetails details) {
        _crashlytics!.recordFlutterError(details);
        FlutterError.presentError(details);
      };

      // Initialize Messaging
      await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get the token
      final fcmToken = await _messaging!.getToken();
      if (fcmToken != null && _auth!.currentUser != null) {
        await _firestore!
            .collection('users')
            .doc(_auth!.currentUser!.uid)
            .update({
              'fcmTokens': FieldValue.arrayUnion([fcmToken]),
              'lastTokenUpdate': FieldValue.serverTimestamp(),
            });
      }

      // Enable Performance Monitoring
      await _performance!.setPerformanceCollectionEnabled(true);

      // Enable offline persistence for Firestore
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Initialize cache manager
      await _cache.initialize();

      // Log app open event
      await _analytics!.logAppOpen();
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Firebase initialization');
      rethrow;
    }
  }

  // Get current user
  static User? get currentUser {
    if (_isDesktop) {
      // Return a mock user for desktop
      return null; // We'll handle this differently in auth methods
    }
    return _auth?.currentUser;
  }

  // Check if user is signed in
  static bool get isSignedIn {
    if (_isDesktop) {
      return true; // Always signed in on desktop for demo
    }
    return _auth?.currentUser != null;
  }

  // Authentication methods
  static Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    if (_isDesktop) {
      // Mock authentication for desktop
      debugPrint('Mock sign in for desktop: $email');
      return null; // Successful mock sign in
    }

    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _analytics!.logLogin(loginMethod: 'email');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      ErrorUtils.handleError(e, context: 'Email/Password sign in');
      rethrow;
    }
  }

  static Future<UserCredential?> registerWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    if (_isDesktop) {
      // Mock user creation for desktop
      debugPrint('Mock user creation for desktop: $email');
      return null; // Successful mock creation
    }

    try {
      final userCredential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(displayName);

      // Create user document
      await _createUserDocument(userCredential.user!, displayName);

      await _analytics!.logSignUp(signUpMethod: 'email');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      ErrorUtils.handleError(e, context: 'Email/Password sign up');
      rethrow;
    }
  }

  static Future<UserCredential?> createUserWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    return registerWithEmailPassword(email, password, displayName);
  }

  static Future<UserCredential?> signInWithGoogle() async {
    if (_isDesktop) {
      // Mock Google sign in for desktop
      debugPrint('Mock Google sign in for desktop');
      return null; // Successful mock sign in
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth!.signInWithCredential(credential);

      // Create user document if first time
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _createUserDocument(
          userCredential.user!,
          userCredential.user!.displayName ?? 'User',
        );
      }

      await _analytics!.logLogin(loginMethod: 'google');
      return userCredential;
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Google sign in');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    if (_isDesktop) {
      debugPrint('Mock sign out for desktop');
      return;
    }

    try {
      await _auth!.signOut();
      await _googleSignIn!.signOut();
      await _analytics!.logEvent(name: 'user_logout');
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Sign out');
      rethrow;
    }
  }

  static Future<void> resetPassword(String email) async {
    if (_isDesktop) {
      debugPrint('Mock password reset for desktop: $email');
      return;
    }

    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Password reset');
      rethrow;
    }
  }

  static Stream<User?> get authStateChanges {
    if (_isDesktop) {
      // Return a stream that emits null for desktop
      return Stream.value(null);
    }
    return _auth!.authStateChanges();
  }

  // User document methods
  static Future<void> _createUserDocument(User user, String displayName) async {
    if (_isDesktop) return;

    final userDoc = _firestore!.collection('users').doc(user.uid);
    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': displayName,
      'photoURL': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    };

    await userDoc.set(userData, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    if (_isDesktop) {
      return Map<String, dynamic>.from(_mockUser);
    }

    try {
      final doc = await _firestore!.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Getting user document');
      return null;
    }
  }

  // Get current user profile data
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    if (_isDesktop) {
      return Map<String, dynamic>.from(_mockUser);
    }

    final currentUser = _auth?.currentUser;
    if (currentUser == null) return null;

    return await getUserDocument(currentUser.uid);
  }

  // Update user profile data (legacy method for backward compatibility)
  static Future<void> updateUserProfileLegacy(
    Map<String, dynamic> profileData,
  ) async {
    if (_isDesktop) {
      // Update mock user data
      _mockUser.addAll(profileData);
      _mockUser['lastUpdated'] = DateTime.now().toIso8601String();
      debugPrint('Updated mock user profile');
      return;
    }

    final currentUser = _auth?.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      profileData['lastUpdated'] = FieldValue.serverTimestamp();
      await _firestore!
          .collection('users')
          .doc(currentUser.uid)
          .update(profileData);
      await _analytics!.logEvent(name: 'profile_updated');
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Updating user profile');
      rethrow;
    }
  }

  // Get user statistics for profile display
  static Future<Map<String, dynamic>> getUserStatistics() async {
    if (_isDesktop) {
      return Map<String, dynamic>.from(_mockUser['statistics'] ?? {});
    }

    final currentUser = _auth?.currentUser;
    if (currentUser == null) return {};

    try {
      // Get assignment statistics
      final assignmentsSnapshot =
          await _firestore!
              .collection('assignments')
              .where('userId', isEqualTo: currentUser.uid)
              .get();

      final assignments = assignmentsSnapshot.docs;
      final completedCount =
          assignments.where((doc) => doc.data()['isCompleted'] == true).length;
      final pendingCount = assignments.length - completedCount;

      // Calculate average score (if available)
      double averageScore = 0.0;
      int scoredAssignments = 0;
      for (final doc in assignments) {
        final score = doc.data()['score'];
        if (score != null && score is num) {
          averageScore += score.toDouble();
          scoredAssignments++;
        }
      }
      averageScore =
          scoredAssignments > 0 ? averageScore / scoredAssignments : 0.0;

      return {
        'assignmentsCompleted': completedCount,
        'assignmentsPending': pendingCount,
        'averageScore': averageScore,
        'totalAssignments': assignments.length,
      };
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Getting user statistics');
      return {};
    }
  }

  // Get user achievements
  static Future<List<Map<String, dynamic>>> getUserAchievements() async {
    if (_isDesktop) {
      return List<Map<String, dynamic>>.from(_mockUser['achievements'] ?? []);
    }

    final currentUser = _auth?.currentUser;
    if (currentUser == null) return [];

    try {
      final doc =
          await _firestore!.collection('users').doc(currentUser.uid).get();
      final userData = doc.data();
      return List<Map<String, dynamic>>.from(userData?['achievements'] ?? []);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Getting user achievements');
      return [];
    }
  }

  // Get user courses
  static Future<List<Map<String, dynamic>>> getUserCourses() async {
    if (_isDesktop) {
      return List<Map<String, dynamic>>.from(_mockUser['courses'] ?? []);
    }

    final currentUser = _auth?.currentUser;
    if (currentUser == null) return [];

    try {
      final doc =
          await _firestore!.collection('users').doc(currentUser.uid).get();
      final userData = doc.data();
      return List<Map<String, dynamic>>.from(userData?['courses'] ?? []);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Getting user courses');
      return [];
    }
  }

  // Assignment methods
  static Future<void> addAssignment(Map<String, dynamic> assignmentData) async {
    if (_isDesktop) {
      // Add to mock data
      final newAssignment = Map<String, dynamic>.from(assignmentData);
      newAssignment['id'] = 'mock_${DateTime.now().millisecondsSinceEpoch}';
      newAssignment['createdAt'] = DateTime.now().toIso8601String();
      _mockAssignments.add(newAssignment);
      debugPrint('Added mock assignment: ${newAssignment['title']}');
      return;
    }

    final currentUser = _auth!.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      assignmentData['userId'] = currentUser.uid;
      assignmentData['createdAt'] = FieldValue.serverTimestamp();

      await _firestore!.collection('assignments').add(assignmentData);
      await _analytics!.logEvent(
        name: 'assignment_added',
        parameters: {'subject': assignmentData['subject']},
      );
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Adding assignment');
      rethrow;
    }
  }

  static Future<List<Assignment>> getUserAssignments() async {
    if (_isDesktop) {
      // Return mock assignments
      return _mockAssignments.map((data) => Assignment.fromMap(data)).toList();
    }

    final currentUser = _auth!.currentUser;
    if (currentUser == null) return [];

    try {
      final querySnapshot =
          await _firestore!
              .collection('assignments')
              .where('userId', isEqualTo: currentUser.uid)
              .orderBy('dueDate', descending: false)
              .get();

      return querySnapshot.docs
          .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Getting user assignments');
      return [];
    }
  }

  static Future<void> updateAssignment(
    String assignmentId,
    Map<String, dynamic> updateData,
  ) async {
    if (_isDesktop) {
      // Update mock data
      final index = _mockAssignments.indexWhere((a) => a['id'] == assignmentId);
      if (index != -1) {
        _mockAssignments[index] = {..._mockAssignments[index], ...updateData};
        debugPrint('Updated mock assignment: $assignmentId');
      }
      return;
    }

    try {
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore!
          .collection('assignments')
          .doc(assignmentId)
          .update(updateData);
      await _analytics!.logEvent(name: 'assignment_updated');
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Updating assignment');
      rethrow;
    }
  }

  static Future<void> deleteAssignment(String assignmentId) async {
    if (_isDesktop) {
      // Remove from mock data
      _mockAssignments.removeWhere((a) => a['id'] == assignmentId);
      debugPrint('Deleted mock assignment: $assignmentId');
      return;
    }

    try {
      await _firestore!.collection('assignments').doc(assignmentId).delete();
      await _analytics!.logEvent(name: 'assignment_deleted');
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Deleting assignment');
      rethrow;
    }
  }

  // Analytics methods
  static Future<void> logScreenView(String screenName) async {
    if (_isDesktop) {
      debugPrint('Mock analytics: Screen view - $screenName');
      return;
    }

    try {
      await _analytics!.logScreenView(screenName: screenName);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Logging screen view');
    }
  }

  static Future<void> logEvent(
    String eventName, [
    Map<String, Object>? parameters,
  ]) async {
    if (_isDesktop) {
      debugPrint('Mock analytics: Event - $eventName');
      return;
    }

    try {
      await _analytics!.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Logging event');
    }
  }

  // Error reporting
  static void recordError(
    dynamic error,
    StackTrace stackTrace, {
    String? reason,
  }) {
    if (_isDesktop) {
      debugPrint('Mock crashlytics: Error - $error');
      return;
    }

    try {
      _crashlytics?.recordError(error, stackTrace, reason: reason);
    } catch (e) {
      debugPrint('Failed to record error: $e');
    }
  }

  static Future<void> setUserIdentifier(String identifier) async {
    if (_isDesktop) {
      debugPrint('Mock crashlytics: User identifier - $identifier');
      return;
    }

    try {
      await _crashlytics?.setUserIdentifier(identifier);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Setting user identifier');
    }
  }

  // Messaging methods (simplified for desktop)
  static Future<void> setupMessageHandlers() async {
    if (_isDesktop) {
      debugPrint('Mock messaging: Setup handlers');
      return;
    }

    try {
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleMessage);

      // Handle when user taps on notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _handleMessage(message, wasOpened: true);
      });

      // Handle initial message if app was opened from notification
      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage, wasOpened: true);
      }
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Setting up message handlers');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    if (_isDesktop) {
      debugPrint('Mock messaging: Subscribe to topic - $topic');
      return;
    }

    try {
      await _messaging!.subscribeToTopic(topic);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Subscribing to topic');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    if (_isDesktop) {
      debugPrint('Mock messaging: Unsubscribe from topic - $topic');
      return;
    }

    try {
      await _messaging!.unsubscribeFromTopic(topic);
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Unsubscribing from topic');
    }
  }

  static void _handleMessage(RemoteMessage message, {bool wasOpened = false}) {
    debugPrint('Handling message: ${message.notification?.title}');
    // Handle message based on your app's needs
  }

  // Storage methods (not implemented for desktop since it's not configured)
  static Future<String> uploadFile(File file, String path) async {
    if (_isDesktop) {
      throw UnsupportedError('File upload not available on desktop');
    }

    try {
      final ref = _storage!.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Uploading file');
      rethrow;
    }
  }

  static Future<void> deleteFile(String path) async {
    if (_isDesktop) {
      throw UnsupportedError('File deletion not available on desktop');
    }

    try {
      await _storage!.ref().child(path).delete();
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Deleting file');
      rethrow;
    }
  }

  // User Profile Management Methods
  static Future<UserProfile?> getUserProfile([String? userId]) async {
    try {
      final uid = userId ?? currentUser?.uid;
      if (uid == null) return null;

      if (_isDesktop) {
        // Return mock profile for desktop
        return UserProfile.fromMap(_mockUser);
      }

      final doc = await _firestore!.collection('userProfiles').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromFirestore(doc);
      }

      // If no profile exists, create a default one from auth data
      final user = currentUser;
      if (user != null) {
        final defaultProfile = UserProfile(
          id: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        await _updateUserProfileDocument(defaultProfile);
        return defaultProfile;
      }

      return null;
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Get user profile');
      return null;
    }
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) return;

      if (_isDesktop) {
        // Mock update for desktop
        debugPrint('Mock profile update for desktop: ${profile.name}');
        return;
      }

      await _firestore!
          .collection('userProfiles')
          .doc(uid)
          .set(profile.toMap(), SetOptions(merge: true));

      await logEvent('profile_updated', {
        'profile_completeness': _calculateProfileCompleteness(profile),
        'has_academic_info': profile.academicInfo != null,
      });
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Update user profile');
      rethrow;
    }
  }

  static Future<void> _updateUserProfileDocument(UserProfile profile) async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) return;

      if (_isDesktop) {
        // Mock update for desktop
        debugPrint('Mock profile update for desktop: ${profile.name}');
        return;
      }

      await _firestore!
          .collection('userProfiles')
          .doc(uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Update user profile document');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUserAcademicStats([
    String? userId,
  ]) async {
    try {
      final uid = userId ?? currentUser?.uid;
      if (uid == null) return {};

      if (_isDesktop) {
        // Return mock academic stats for desktop
        return {
          'totalCourses': 12,
          'completedCourses': 8,
          'attendanceRate': 85.5,
          'currentGPA': 4.2,
          'totalCredits': 48,
          'totalAssignments': _mockAssignments.length,
          'completedAssignments':
              _mockAssignments.where((a) => a['isCompleted'] == true).length,
          'pendingAssignments':
              _mockAssignments.where((a) => a['isCompleted'] == false).length,
        };
      }

      // Get user assignments for real calculations
      final assignments = await getUserAssignments();
      final profile = await getUserProfile(uid);

      final stats = profile?.getAcademicStats() ?? {};

      // Add assignment-based stats
      stats['totalAssignments'] = assignments.length;
      stats['completedAssignments'] =
          assignments.where((a) => a.isCompleted).length;
      stats['pendingAssignments'] =
          assignments.where((a) => !a.isCompleted).length;

      return stats;
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Get academic stats');
      return {};
    }
  }

  static int _calculateProfileCompleteness(UserProfile profile) {
    int completeness = 0;

    if (profile.name.isNotEmpty) completeness += 20;
    if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty) {
      completeness += 15;
    }
    if (profile.dateOfBirth != null) completeness += 10;
    if (profile.address != null && profile.address!.isNotEmpty) {
      completeness += 10;
    }
    if (profile.grade != null) completeness += 15;
    if (profile.major != null) completeness += 15;
    if (profile.studentId != null && profile.studentId!.isNotEmpty) {
      completeness += 15;
    }

    return completeness;
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}
