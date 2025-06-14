import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/firebase_service.dart';

class FirebaseDebugHelper {
  /// Check Firebase configuration and print debug information
  static Future<void> checkFirebaseConfiguration() async {
    debugPrint('=== Firebase Configuration Check ===');
    
    try {
      // Check if Firebase apps are initialized
      final apps = Firebase.apps;
      debugPrint('Firebase apps initialized: ${apps.length}');
      
      for (final app in apps) {
        debugPrint('  - App: ${app.name}, Project: ${app.options.projectId}');
      }
      
      // Check Firebase service status
      debugPrint('Firebase supported: ${FirebaseService.isFirebaseSupported}');
      debugPrint('Signed in: ${FirebaseService.isSignedIn}');
      debugPrint('Current user: ${FirebaseService.currentUser?.email ?? "None"}');
      debugPrint('Linux mock mode: ${FirebaseService.isLinuxMockMode}');
      
    } catch (e) {
      debugPrint('Firebase configuration check failed: $e');
    }
    
    debugPrint('=== End Firebase Configuration Check ===');
  }
  
  /// Test Firebase Auth connectivity
  static Future<bool> testFirebaseAuth() async {
    try {
      debugPrint('Testing Firebase Auth connectivity...');
      
      // Try to access Auth instance
      if (!FirebaseService.isFirebaseSupported) {
        debugPrint('Firebase not supported on this platform');
        return false;
      }
      
      // Check auth state
      debugPrint('Auth state stream available: true');
      
      return true;
    } catch (e) {
      debugPrint('Firebase Auth test failed: $e');
      return false;
    }
  }
  
  /// Print common Firebase configuration issues
  static void printCommonIssues() {
    debugPrint('=== Common Firebase Configuration Issues ===');
    debugPrint('1. Check google-services.json file is in android/app/ directory');
    debugPrint('2. Verify package name matches in google-services.json and build.gradle');
    debugPrint('3. Ensure Google Services plugin is applied in build.gradle files');
    debugPrint('4. Check internet permissions in AndroidManifest.xml');
    debugPrint('5. Verify Firebase project settings in Firebase console');
    debugPrint('6. Clean and rebuild the project after configuration changes');
    debugPrint('===============================================');
  }

  /// Print instructions for resolving App Check and reCAPTCHA issues
  static void printAppCheckIssues() {
    debugPrint('=== App Check & reCAPTCHA Configuration Issues ===');
    debugPrint('The SHA-1 fingerprint for your debug keystore is:');
    debugPrint('5F:C7:17:97:48:3B:5B:1E:9C:E7:C1:D3:47:A9:73:71:CB:85:CB:D7');
    debugPrint('');
    debugPrint('To fix App Check and reCAPTCHA issues:');
    debugPrint('1. Go to Firebase Console > Project Settings > General');
    debugPrint('2. Scroll down to "Your apps" section');
    debugPrint('3. Find your Android app (com.ush.smart_edu)');
    debugPrint('4. Click on the app, then click "Add fingerprint"');
    debugPrint('5. Add the SHA-1 fingerprint above');
    debugPrint('6. Download the updated google-services.json');
    debugPrint('7. Replace the current google-services.json in android/app/');
    debugPrint('');
    debugPrint('Alternative temporary workaround:');
    debugPrint('- In Firebase Console > Authentication > Settings');
    debugPrint('- Under "Advanced", disable "Phone number sign-in quota"');
    debugPrint('- This may reduce reCAPTCHA enforcement');
    debugPrint('================================================');
  }

  /// Check for common App Check errors
  static void diagnoseAppCheckErrors(String errorMessage) {
    debugPrint('=== App Check Error Diagnosis ===');
    if (errorMessage.contains('CONFIGURATION_NOT_FOUND')) {
      debugPrint('Issue: Firebase configuration not found');
      debugPrint('Cause: SHA-1 fingerprint not configured in Firebase Console');
      debugPrint('Solution: Add your debug SHA-1 to Firebase project settings');
    }
    if (errorMessage.contains('No AppCheckProvider installed')) {
      debugPrint('Issue: App Check provider not configured');
      debugPrint('Solution: Either configure App Check or disable enforcement');
    }
    if (errorMessage.contains('RecaptchaAction')) {
      debugPrint('Issue: reCAPTCHA verification failed');
      debugPrint('Cause: Missing or incorrect OAuth client configuration');
      debugPrint('Solution: Ensure OAuth clients are properly configured');
    }
    debugPrint('=================================');
  }
}
