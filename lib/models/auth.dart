import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class Auth {
  // Check if user is logged in
  static bool get isLoggedIn => FirebaseService.isSignedIn;

  // Get current user
  static User? get currentUser => FirebaseService.currentUser;

  // Get user email
  static String? get userEmail => FirebaseService.currentUser?.email;

  // Get user name
  static String? get userName => FirebaseService.currentUser?.displayName;

  // Auth state changes stream
  static Stream<User?> get authStateChanges => FirebaseService.authStateChanges;

  // Login method using Firebase
  static Future<bool> login(String email, String password) async {
    try {
      final credential = await FirebaseService.signInWithEmailPassword(
        email,
        password,
      );
      return credential != null;
    } catch (e) {
      return false;
    }
  }

  // Google Sign In
  static Future<bool> signInWithGoogle() async {
    try {
      final credential = await FirebaseService.signInWithGoogle();
      return credential != null;
    } catch (e) {
      return false;
    }
  }

  // Register method using Firebase
  static Future<bool> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await FirebaseService.registerWithEmailPassword(
        email,
        password,
        displayName,
      );
      return credential != null;
    } catch (e) {
      return false;
    }
  }

  // Reset password
  static Future<bool> resetPassword(String email) async {
    try {
      await FirebaseService.resetPassword(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout method
  static Future<void> logout() async {
    await FirebaseService.signOut();
  }
}
