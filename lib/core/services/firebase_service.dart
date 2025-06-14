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
import '../config/firebase_options.dart';
import '../../../core/utils/cache_manager.dart';
import '../../features/assignments/models/assignment.dart';
import '../../shared/models/user_profile.dart';
import '../../features/auth/models/profile_settings.dart';
import '../../../core/data/mock_data.dart';

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
  static bool _useLinuxMockAuth = false; // Fallback for Linux when Firebase fails

  // Platform detection
  static bool get _isUnsupportedDesktop =>
      Platform.isWindows || Platform.isMacOS; // Linux is supported!
  static bool get isFirebaseSupported => !_isUnsupportedDesktop;
  static bool get isLinuxMockMode => Platform.isLinux && _useLinuxMockAuth;

  // Initialize Firebase
  static Future<void> initialize() async {
    if (_isUnsupportedDesktop) {
      debugPrint('Running on unsupported desktop platform - using mock data');
      return;
    }

    // Special handling for Linux - Firebase might not be fully supported
    if (Platform.isLinux) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        // Skip analytics, messaging, etc. on Linux for now
        debugPrint('Firebase initialized successfully on Linux (limited features)');
      } catch (e) {
        debugPrint('Firebase initialization failed on Linux: $e');
        debugPrint('Falling back to mock authentication for Linux');
        // Set a flag to use mock authentication
        _useLinuxMockAuth = true;
        return;
      }
    } else {
      // Full Firebase initialization for mobile platforms
      try {
        debugPrint('Initializing Firebase for platform: ${Platform.operatingSystem}');
        
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        _analytics = FirebaseAnalytics.instance;
        _crashlytics = FirebaseCrashlytics.instance;
        _messaging = FirebaseMessaging.instance;
        _performance = FirebasePerformance.instance;
        _storage = FirebaseStorage.instance;
        _googleSignIn = GoogleSignIn();

        // Configure Firebase Auth settings for better compatibility
        if (_auth != null) {
          // Set language code if needed
          _auth!.setLanguageCode('en');
          debugPrint('Firebase Auth configured successfully');
        }

        // Enable crash collection
        if (_crashlytics != null) {
          await _crashlytics!.setCrashlyticsCollectionEnabled(true);
        }

        debugPrint('Firebase initialized successfully');
        debugPrint('Auth instance: ${_auth != null}');
        debugPrint('Firestore instance: ${_firestore != null}');
      } catch (e) {
        debugPrint('Firebase initialization failed: $e');
        debugPrint('Error type: ${e.runtimeType}');
        if (e.toString().contains('google-services.json')) {
          debugPrint('Please check that google-services.json file is properly configured');
        }
        rethrow;
      }
    }
  }

  // Setup message handlers
  static Future<void> setupMessageHandlers() async {
    if (_isUnsupportedDesktop || _messaging == null) return;

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestNotificationPermission();
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('Background message: ${message.notification?.title}');
  }

  static Future<void> _requestNotificationPermission() async {
    if (_messaging == null) return;

    final settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Notification permission granted');
    }
  }

  // Authentication methods
  static bool get isSignedIn {
    if (_isUnsupportedDesktop) return true;
    return _auth?.currentUser != null;
  }

  static User? get currentUser {
    if (_isUnsupportedDesktop) return null;
    return _auth?.currentUser;
  }

  static String? get currentUserId {
    if (_isUnsupportedDesktop) return 'mock_user_123';
    return _auth?.currentUser?.uid;
  }

  static String? get currentUserEmail {
    if (_isUnsupportedDesktop) return 'alex.johnson@smartedu.com';
    return _auth?.currentUser?.email;
  }

  static Stream<User?> get authStateChanges {
    if (_isUnsupportedDesktop) return Stream.value(null);
    return _auth?.authStateChanges() ?? Stream.value(null);
  }

  static Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop sign in: $email');
      return null;
    }

    // Handle Linux mock authentication if Firebase failed to initialize
    if (Platform.isLinux && _useLinuxMockAuth) {
      debugPrint('Linux mock sign in: $email');
      // For development purposes, allow any email/password combination
      // In production, you might want to have specific test credentials
      return null; // Return null but don't throw error
    }

    if (_auth == null) {
      throw Exception('Firebase Auth is not initialized. Please check Firebase configuration.');
    }

    try {
      debugPrint('Attempting to sign in with email: $email');
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Sign in successful for user: ${credential.user?.uid}');
      
      if (_analytics != null) {
        await _analytics!.logLogin(loginMethod: 'email');
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth error: ${e.code} - ${e.message}');
      
      // Check for configuration issues
      if (e.code == 'unknown' && e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
        debugPrint('');
        debugPrint('⚠️  CONFIGURATION ERROR DETECTED ⚠️');
        debugPrint('SHA-1 Debug Key: 5F:C7:17:97:48:3B:5B:1E:9C:E7:C1:D3:47:A9:73:71:CB:85:CB:D7');
        debugPrint('Please add this fingerprint to your Firebase project settings.');
        debugPrint('');
      }
      
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided for that user.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        case 'too-many-requests':
          throw Exception('Too many failed attempts. Please try again later.');
        case 'unknown':
          if (e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
            throw Exception('Firebase configuration error. Please check that your SHA-1 fingerprint is added to Firebase Console.');
          } else {
            throw Exception('Authentication failed: ${e.message}');
          }
        default:
          throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      debugPrint('General sign in error: $e');
      
      // Check for App Check related errors
      if (e.toString().contains('AppCheckProvider') || e.toString().contains('CONFIGURATION_NOT_FOUND')) {
        debugPrint('');
        debugPrint('🔧 App Check Configuration Issue Detected');
        debugPrint('Please add SHA-1 fingerprint: 5F:C7:17:97:48:3B:5B:1E:9C:E7:C1:D3:47:A9:73:71:CB:85:CB:D7');
        debugPrint('to Firebase Console > Project Settings > Your apps > Android app');
        debugPrint('');
      }
      
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop Google sign in not supported');
      return null;
    }

    // Google Sign-In on Linux might have limitations
    if (Platform.isLinux) {
      debugPrint('Google Sign-In on Linux may have limitations');
      // For now, we'll still attempt it, but could fallback to email/password only
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
      
      if (_analytics != null) {
        await _analytics!.logLogin(loginMethod: 'google');
      }
      
      return userCredential;
    } catch (e) {
      debugPrint('Google sign in failed: $e');
      rethrow;
    }
  }

  static Future<UserCredential?> registerWithEmailPassword(
    String email,
    String password, {
    String? displayName,
    String? userRole,
  }) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop registration: $email');
      return null;
    }

    // Handle Linux mock authentication if Firebase failed to initialize
    if (Platform.isLinux && _useLinuxMockAuth) {
      debugPrint('Linux mock registration: $email with role: $userRole');
      
      // Simulate successful registration by creating mock user data locally
      // This is for development purposes on Linux
      if (displayName != null && userRole != null) {
        try {
          // Create mock user data locally (could be stored in SharedPreferences or local file)
          await _createMockUserData(email, displayName, userRole);
          debugPrint('Mock user data created locally for Linux');
        } catch (e) {
          debugPrint('Failed to create mock user data: $e');
        }
      }
      
      return null; // Return null but indicate success through other means
    }

    if (_auth == null) {
      throw Exception('Firebase Auth is not initialized. Please check Firebase configuration.');
    }

    try {
      debugPrint('Attempting to register user with email: $email');
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Registration successful for user: ${credential.user?.uid}');
      
      // Update the user's display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        debugPrint('Display name updated to: $displayName');
      }
      
      // Create initial user data based on role
      if (credential.user != null && userRole != null) {
        debugPrint('Creating initial user data with role: $userRole');
        await _createInitialUserData(
          credential.user!.uid,
          email,
          displayName ?? 'User',
          userRole,
        );
      }
      
      if (_analytics != null) {
        await _analytics!.logSignUp(signUpMethod: 'email');
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth registration error: ${e.code} - ${e.message}');
      
      // Import and use debug helper for specific error diagnosis
      if (e.code == 'unknown' && e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
        debugPrint('');
        debugPrint('⚠️  CONFIGURATION ERROR DETECTED ⚠️');
        debugPrint('This error typically means the SHA-1 fingerprint is not configured in Firebase Console.');
        debugPrint('SHA-1 Debug Key: 5F:C7:17:97:48:3B:5B:1E:9C:E7:C1:D3:47:A9:73:71:CB:85:CB:D7');
        debugPrint('Please add this fingerprint to your Firebase project settings.');
        debugPrint('');
      }
      
      switch (e.code) {
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        case 'email-already-in-use':
          throw Exception('An account already exists for that email.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled.');
        case 'unknown':
          if (e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
            throw Exception('Firebase configuration error. Please check that your SHA-1 fingerprint is added to Firebase Console.');
          } else {
            throw Exception('Registration failed: ${e.message}');
          }
        default:
          throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      debugPrint('General registration error: $e');
      
      // Check for App Check related errors
      if (e.toString().contains('AppCheckProvider') || e.toString().contains('CONFIGURATION_NOT_FOUND')) {
        debugPrint('');
        debugPrint('🔧 App Check Configuration Issue Detected');
        debugPrint('This appears to be related to Firebase App Check or reCAPTCHA configuration.');
        debugPrint('For debugging, you may need to:');
        debugPrint('1. Add SHA-1 fingerprint to Firebase Console');
        debugPrint('2. Configure App Check in Firebase Console');
        debugPrint('3. Or temporarily disable App Check enforcement');
        debugPrint('');
      }
      
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Creates mock user data for Linux development when Firebase is unavailable
  static Future<void> _createMockUserData(String email, String displayName, String userRole) async {
    try {
      // Split display name into first and last name
      final nameParts = displayName.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      // Create user data package using MockData
      final userDataPackage = MockData.createUserDataPackage(
        uid: 'linux_mock_${email.hashCode}', // Generate a mock UID
        email: email,
        firstName: firstName,
        lastName: lastName,
        userType: userRole,
      );
      
      debugPrint('Mock user data package created for Linux:');
      debugPrint('  - Profile: ${userDataPackage['profile']['displayName']}');
      debugPrint('  - Role: ${userDataPackage['userType']}');
      debugPrint('  - Assignments: ${(userDataPackage['assignments'] as List).length} initial tasks');
      
      // In a real implementation, you might save this to SharedPreferences or a local database
      // For now, we just log it for demonstration
    } catch (e) {
      debugPrint('Failed to create mock user data: $e');
      rethrow;
    }
  }

  /// Creates initial user data including profile, assignments, and academic stats
  static Future<void> _createInitialUserData(
    String uid,
    String email,
    String displayName,
    String userRole,
  ) async {
    try {
      // Split display name into first and last name
      final nameParts = displayName.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      // Create user data package using MockData
      final userDataPackage = MockData.createUserDataPackage(
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userType: userRole,
      );
      
      if (_firestore != null) {
        final batch = _firestore!.batch();
        
        // Create user profile
        final userProfileRef = _firestore!.collection('users').doc(uid);
        batch.set(userProfileRef, userDataPackage['profile']);
        
        // Create initial assignments
        final assignments = userDataPackage['assignments'] as List<Map<String, dynamic>>;
        for (final assignment in assignments) {
          final assignmentRef = _firestore!.collection('assignments').doc();
          batch.set(assignmentRef, assignment);
        }
        
        // Create academic stats
        final academicStatsRef = _firestore!.collection('academic_stats').doc(uid);
        batch.set(academicStatsRef, userDataPackage['academicStats']);
        
        await batch.commit();
        debugPrint('Created initial user data for $userRole: $uid');
      }
    } catch (e) {
      debugPrint('Failed to create initial user data: $e');
      // Don't rethrow - registration should still succeed even if this fails
    }
  }

  static Future<void> resetPassword(String email) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop password reset: $email');
      return;
    }

    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Password reset failed: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop sign out');
      return;
    }

    try {
      await _auth!.signOut();
      await _googleSignIn!.signOut();
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'logout');
      }
    } catch (e) {
      debugPrint('Sign out failed: $e');
      rethrow;
    }
  }

  // Firestore operations
  static Future<Map<String, dynamic>?> getUserProfile() async {
    if (_isUnsupportedDesktop) {
      return MockData.userProfile;
    }

    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final doc = await _firestore!.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('Get user profile failed: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserAcademicStats() async {
    if (_isUnsupportedDesktop) {
      return MockData.getAcademicStats();
    }

    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final doc = await _firestore!.collection('academic_stats').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('Get academic stats failed: $e');
      return null;
    }
  }

  static Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop update profile: $data');
      return;
    }

    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore!.collection('users').doc(userId).set(
        data..['updatedAt'] = FieldValue.serverTimestamp(),
        SetOptions(merge: true),
      );
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'profile_updated');
      }
    } catch (e) {
      debugPrint('Update user profile failed: $e');
      rethrow;
    }
  }

  // Assignment operations
  static Future<List<Assignment>> getUserAssignments() async {
    if (_isUnsupportedDesktop) {
      return MockData.assignments.map((data) => Assignment.fromMap(data)).toList();
    }

    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final querySnapshot = await _firestore!
          .collection('assignments')
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate')
          .get();

      return querySnapshot.docs
          .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Get assignments failed: $e');
      return [];
    }
  }

  static Future<String> addAssignment(Assignment assignment) async {
    if (_isUnsupportedDesktop) {
      final id = 'mock_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Desktop add assignment: $id');
      return id;
    }

    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final data = assignment.toMap()
        ..['userId'] = userId
        ..['createdAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore!.collection('assignments').add(data);
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'assignment_added');
      }
      
      return docRef.id;
    } catch (e) {
      debugPrint('Add assignment failed: $e');
      rethrow;
    }
  }

  static Future<void> updateAssignment(String id, Assignment assignment) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop update assignment: $id');
      return;
    }

    try {
      final data = assignment.toMap()
        ..['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore!.collection('assignments').doc(id).update(data);
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'assignment_updated');
      }
    } catch (e) {
      debugPrint('Update assignment failed: $e');
      rethrow;
    }
  }

  static Future<void> deleteAssignment(String id) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop delete assignment: $id');
      return;
    }

    try {
      await _firestore!.collection('assignments').doc(id).delete();
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'assignment_deleted');
      }
    } catch (e) {
      debugPrint('Delete assignment failed: $e');
      rethrow;
    }
  }

  // Teacher-specific operations
  static Future<List<Assignment>> getTeacherAssignments() async {
    if (_isUnsupportedDesktop) {
      return MockData.assignments.map((data) => Assignment.fromMap(data)).toList();
    }

    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final querySnapshot = await _firestore!
          .collection('assignments')
          .where('teacherId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Get teacher assignments failed: $e');
      return [];
    }
  }

  // Student-specific operations
  static Future<List<Assignment>> getStudentAssignments() async {
    if (_isUnsupportedDesktop) {
      return MockData.assignments.map((data) => Assignment.fromMap(data)).toList();
    }

    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final querySnapshot = await _firestore!
          .collection('assignments')
          .where('assignedTo', arrayContains: userId)
          .orderBy('dueDate')
          .get();

      return querySnapshot.docs
          .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Get student assignments failed: $e');
      return [];
    }
  }

  static Future<List<UserProfile>> getStudents() async {
    if (_isUnsupportedDesktop) {
      // Return mock student data
      return [
        UserProfile(
          id: 'mock_student_1',
          name: 'John Doe',
          email: 'john.doe@school.edu',
          role: 'student',
          grade: '10th',
        ),
        UserProfile(
          id: 'mock_student_2',
          name: 'Jane Smith',
          email: 'jane.smith@school.edu',
          role: 'student',
          grade: '10th',
        ),
      ];
    }

    try {
      final querySnapshot = await _firestore!
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      return querySnapshot.docs
          .map((doc) => UserProfile.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Get students failed: $e');
      return [];
    }
  }

  static Future<UserProfile?> getCurrentUserProfile() async {
    if (_isUnsupportedDesktop) {
      return UserProfile(
        id: 'mock_teacher_1',
        name: 'Teacher Mock',
        email: 'teacher@school.edu',
        role: 'teacher',
      );
    }

    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final doc = await _firestore!.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      return UserProfile.fromMap({...doc.data()!, 'id': doc.id});
    } catch (e) {
      debugPrint('Get current user profile failed: $e');
      return null;
    }
  }

  // Analytics
  static Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop analytics: $name');
      return;
    }

    try {
      if (_analytics != null) {
        await _analytics!.logEvent(name: name, parameters: parameters);
      }
    } catch (e) {
      debugPrint('Log event failed: $e');
    }
  }

  static Future<void> logScreenView(String screenName) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop screen view: $screenName');
      return;
    }

    try {
      if (_analytics != null) {
        await _analytics!.logScreenView(screenName: screenName);
      }
    } catch (e) {
      debugPrint('Log screen view failed: $e');
    }
  }

  // Crash reporting
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop error: $exception');
      return;
    }

    try {
      if (_crashlytics != null) {
        await _crashlytics!.recordError(exception, stackTrace, fatal: fatal);
      }
    } catch (e) {
      debugPrint('Record error failed: $e');
    }
  }

  static Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop Flutter error: ${details.exception}');
      return;
    }

    try {
      if (_crashlytics != null) {
        await _crashlytics!.recordFlutterFatalError(details);
      }
    } catch (e) {
      debugPrint('Record Flutter error failed: $e');
    }
  }

  // Messaging
  static Future<String?> getMessagingToken() async {
    if (_isUnsupportedDesktop) return null;

    try {
      return await _messaging?.getToken();
    } catch (e) {
      debugPrint('Get messaging token failed: $e');
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    if (_isUnsupportedDesktop) return;

    try {
      await _messaging?.subscribeToTopic(topic);
    } catch (e) {
      debugPrint('Subscribe to topic failed: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    if (_isUnsupportedDesktop) return;

    try {
      await _messaging?.unsubscribeFromTopic(topic);
    } catch (e) {
      debugPrint('Unsubscribe from topic failed: $e');
    }
  }

  // Storage
  static Future<String?> uploadFile(String path, Uint8List data) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop file upload: $path');
      return 'mock_upload_url';
    }

    try {
      final ref = _storage!.ref(path);
      final uploadTask = ref.putData(data);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('File upload failed: $e');
      return null;
    }
  }

  static Future<void> deleteFile(String path) async {
    if (_isUnsupportedDesktop) return;

    try {
      await _storage!.ref(path).delete();
    } catch (e) {
      debugPrint('File deletion failed: $e');
    }
  }

  // Performance monitoring
  static Future<void> startTrace(String name) async {
    if (_isUnsupportedDesktop) return;

    try {
      final trace = _performance?.newTrace(name);
      await trace?.start();
    } catch (e) {
      debugPrint('Start trace failed: $e');
    }
  }

  static Future<void> stopTrace(String name) async {
    if (_isUnsupportedDesktop) return;

    try {
      // Note: In a real implementation, you'd need to track traces
      debugPrint('Stop trace: $name');
    } catch (e) {
      debugPrint('Stop trace failed: $e');
    }
  }

  // Cache management
  static Future<T?> getCachedData<T>(String key) async {
    try {
      return await _cache.getCachedData<T>(key);
    } catch (e) {
      debugPrint('Get cached data failed: $e');
      return null;
    }
  }

  static Future<void> setCachedData<T>(String key, T data, {Duration? expiry}) async {
    try {
      await _cache.cacheData(key, data, expiration: expiry);
    } catch (e) {
      debugPrint('Set cached data failed: $e');
    }
  }

  static Future<void> clearCache() async {
    try {
      await _cache.clearAllCache();
    } catch (e) {
      debugPrint('Clear cache failed: $e');
    }
  }

  // Profile Settings operations
  static Future<ProfileSettings?> getProfileSettings() async {
    if (_isUnsupportedDesktop) {
      // Return mock profile settings
      return ProfileSettings(
        id: 'mock_profile_1',
        userId: 'mock_user_1',
        firstName: 'John',
        lastName: 'Doe',
        displayName: 'John Doe',
        role: 'student',
        phoneNumber: '+1234567890',
        institutionName: 'Smart Education Institute',
        grade: '10th',
        isProfileComplete: false,
      );
    }

    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final doc = await _firestore!.collection('profile_settings').doc(userId).get();
      if (!doc.exists) return null;

      return ProfileSettings.fromMap({...doc.data()!, 'id': doc.id});
    } catch (e) {
      debugPrint('Get profile settings failed: $e');
      return null;
    }
  }

  static Future<String> createProfileSettings(ProfileSettings profileSettings) async {
    if (_isUnsupportedDesktop) {
      final id = 'mock_profile_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Desktop create profile settings: $id');
      return id;
    }

    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final data = profileSettings.toMap()
        ..['userId'] = userId
        ..['createdAt'] = FieldValue.serverTimestamp();

      await _firestore!.collection('profile_settings').doc(userId).set(data);
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'profile_settings_created');
      }
      
      return userId;
    } catch (e) {
      debugPrint('Create profile settings failed: $e');
      rethrow;
    }
  }

  static Future<void> updateProfileSettings(ProfileSettings profileSettings) async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop update profile settings: ${profileSettings.id}');
      return;
    }

    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final data = profileSettings.toMap()
        ..['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore!.collection('profile_settings').doc(userId).update(data);
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'profile_settings_updated');
      }
    } catch (e) {
      debugPrint('Update profile settings failed: $e');
      rethrow;
    }
  }

  static Future<void> deleteProfileSettings() async {
    if (_isUnsupportedDesktop) {
      debugPrint('Desktop delete profile settings');
      return;
    }

    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore!.collection('profile_settings').doc(userId).delete();
      
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'profile_settings_deleted');
      }
    } catch (e) {
      debugPrint('Delete profile settings failed: $e');
      rethrow;
    }
  }
}