import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Utility class for handling errors in the application
class ErrorUtils {
  /// Handle errors by logging them to the console and to Firebase Crashlytics
  ///
  /// Parameters:
  /// - [error] The error object
  /// - [stack] The stack trace
  /// - [context] A string describing where the error occurred
  /// - [fatal] Whether the error is fatal
  static void handleError(
    dynamic error, {
    StackTrace? stack,
    String context = 'Unknown context',
    bool fatal = false,
  }) {
    // Always print error to console
    debugPrint('Error in $context: $error');
    if (stack != null) {
      debugPrint('Stack trace: $stack');
    }

    // Log to Crashlytics in non-debug mode and on supported platforms
    if (!kDebugMode &&
        !(Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      try {
        // Dynamically import FirebaseService to avoid circular dependencies
        // FirebaseService.recordError(
        //   error,
        //   stack ?? StackTrace.current,
        //   reason: context,
        // );
      } catch (e) {
        debugPrint('Failed to log error to Firebase: $e');
      }
    }
  }

  /// Set up a zone to catch all uncaught errors
  static R runWithErrorHandling<R>(R Function() body) {
    return runZonedGuarded(body, (error, stackTrace) {
          handleError(
            error,
            stack: stackTrace,
            context: 'Uncaught exception in zone',
          );
        })
        as R;
  }

  /// Create user-friendly error message from a technical error
  static String getUserFriendlyErrorMessage(dynamic error) {
    if (error is Exception) {
      final String errorString = error.toString().toLowerCase();

      // Network errors
      if (errorString.contains('socket') ||
          errorString.contains('network') ||
          errorString.contains('connection')) {
        return 'Network connection error. Please check your internet connection and try again.';
      }

      // Timeout errors
      if (errorString.contains('timeout')) {
        return 'The operation timed out. Please try again later.';
      }

      // Permission errors
      if (errorString.contains('permission')) {
        return 'You don\'t have permission to perform this action.';
      }

      // Firebase errors
      if (errorString.contains('firebase') ||
          errorString.contains('channel-error')) {
        return 'Service temporarily unavailable. Using offline mode.';
      }
    }

    // Default message for unknown errors
    return 'An unexpected error occurred. Please try again later.';
  }
}
