import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppUtils {
  // Private constructor to prevent instantiation
  AppUtils._();

  /// Configure system UI overlay style for better integration with app theme
  static void configureSystemUI({required bool isDarkMode}) {
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: const Color(0xFF1E1E1E),
            systemNavigationBarIconBrightness: Brightness.light,
          )
          : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
    );
  }

  /// Optimize widget rebuilds using this key generator
  static Key uniqueKey(String id) => Key('key_$id');

  /// Create a widget key for list items to optimize performance
  static Key listItemKey(String prefix, int index) => Key('${prefix}_$index');

  /// Generate a unique ID for new items
  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  /// Format a date string in a user-friendly format
  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference > 1 && difference < 7) {
        return '${_getDayName(date)} ($difference days)';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }

  /// Get day name from a DateTime object
  static String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  /// Show a customized snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    bool isError = false,
  }) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
        duration: duration,
        backgroundColor:
            isError ? Colors.red.shade800 : theme.colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: action,
      ),
    );
  }

  /// Cache configuration for better app performance
  static const imageCache = {
    'maxSizeBytes': 100 * 1024 * 1024, // 100 MB
    'maxAge': Duration(days: 7),
  };
}
