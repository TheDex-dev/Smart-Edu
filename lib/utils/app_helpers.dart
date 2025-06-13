import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Advanced state management utilities for better performance
class StateManager {
  static final Map<String, dynamic> _globalState = {};
  static final Map<String, List<VoidCallback>> _listeners = {};

  /// Set global state value
  static void setState(String key, dynamic value) {
    _globalState[key] = value;
    _notifyListeners(key);
  }

  /// Get global state value
  static T? getState<T>(String key) {
    return _globalState[key] as T?;
  }

  /// Subscribe to state changes
  static void subscribe(String key, VoidCallback callback) {
    _listeners.putIfAbsent(key, () => []).add(callback);
  }

  /// Unsubscribe from state changes
  static void unsubscribe(String key, VoidCallback callback) {
    _listeners[key]?.remove(callback);
  }

  /// Clear all state
  static void clearState() {
    _globalState.clear();
    _listeners.clear();
  }

  static void _notifyListeners(String key) {
    _listeners[key]?.forEach((callback) => callback());
  }
}

/// Enhanced form validation utilities
class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateLength(
    String? value,
    int min,
    int max,
    String fieldName,
  ) {
    if (value == null) return '$fieldName is required';

    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }

    if (value.length > max) {
      return '$fieldName cannot exceed $max characters';
    }

    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }

    if (date.isBefore(DateTime.now().subtract(const Duration(days: 365)))) {
      return 'Date cannot be more than a year in the past';
    }

    if (date.isAfter(DateTime.now().add(const Duration(days: 365 * 5)))) {
      return 'Date cannot be more than 5 years in the future';
    }

    return null;
  }
}

/// Responsive design utilities
class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 360) {
      return baseFontSize * 0.9;
    } else if (screenWidth > 600) {
      return baseFontSize * 1.1;
    }

    return baseFontSize;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  static double getResponsiveCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isMobile(context)) {
      return screenWidth - 32;
    } else if (isTablet(context)) {
      return screenWidth * 0.7;
    } else {
      return 600;
    }
  }
}

/// Haptic feedback utilities
class HapticUtils {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void buttonPress() {
    HapticFeedback.lightImpact();
  }

  static void errorFeedback() {
    HapticFeedback.heavyImpact();
  }

  static void successFeedback() {
    HapticFeedback.mediumImpact();
  }
}

/// Network connectivity utilities
class ConnectivityUtils {
  static bool _isOnline = true;
  static final List<VoidCallback> _connectivityListeners = [];

  static bool get isOnline => _isOnline;

  static void addConnectivityListener(VoidCallback callback) {
    _connectivityListeners.add(callback);
  }

  static void removeConnectivityListener(VoidCallback callback) {
    _connectivityListeners.remove(callback);
  }

  static void updateConnectivityStatus(bool isConnected) {
    if (_isOnline != isConnected) {
      _isOnline = isConnected;
      for (final callback in _connectivityListeners) {
        callback();
      }
    }
  }

  static void showConnectivitySnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_isOnline ? Icons.wifi : Icons.wifi_off, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              _isOnline ? 'Connected to internet' : 'No internet connection',
            ),
          ],
        ),
        backgroundColor: _isOnline ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Error handling utilities
class ErrorUtils {
  static void handleError(
    dynamic error, {
    StackTrace? stack,
    String context = 'Unknown context',
    bool fatal = false,
  }) {
    debugPrint('Error in $context: $error');
    if (stack != null) {
      debugPrint('Stack trace: $stack');
    }

    // In a real app, we'd log to Firebase Crashlytics here
    // This is now handled in the FirebaseService class
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
