import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubjectUtils {
  // Get image URL for subject
  static String getImageForSubject(String subject) {
    final String normalizedSubject = subject.toLowerCase();

    if (normalizedSubject.contains('math')) {
      return 'https://picsum.photos/seed/mathematics/400/200';
    } else if (normalizedSubject.contains('science')) {
      return 'https://picsum.photos/seed/science/400/200';
    } else if (normalizedSubject.contains('history')) {
      return 'https://picsum.photos/seed/history/400/200';
    } else if (normalizedSubject.contains('english') ||
        normalizedSubject.contains('language')) {
      return 'https://picsum.photos/seed/english/400/200';
    } else if (normalizedSubject.contains('art')) {
      return 'https://picsum.photos/seed/art/400/200';
    } else if (normalizedSubject.contains('music')) {
      return 'https://picsum.photos/seed/music/400/200';
    } else if (normalizedSubject.contains('computer') ||
        normalizedSubject.contains('programming')) {
      return 'https://picsum.photos/seed/programming/400/200';
    } else {
      // Generate a deterministic but random image based on subject name
      return 'https://picsum.photos/seed/${normalizedSubject.replaceAll(' ', '')}/400/200';
    }
  }

  // Get color for subject
  static Color getColorForSubject(String subject) {
    final String normalizedSubject = subject.toLowerCase();

    if (normalizedSubject.contains('math')) {
      return Colors.blue;
    } else if (normalizedSubject.contains('science')) {
      return Colors.green;
    } else if (normalizedSubject.contains('history')) {
      return Colors.brown;
    } else if (normalizedSubject.contains('english') ||
        normalizedSubject.contains('language')) {
      return Colors.purple;
    } else if (normalizedSubject.contains('art')) {
      return Colors.pink;
    } else if (normalizedSubject.contains('music')) {
      return Colors.indigo;
    } else if (normalizedSubject.contains('computer') ||
        normalizedSubject.contains('programming')) {
      return Colors.teal;
    } else {
      // Default color
      return Colors.deepPurple;
    }
  }

  // Format due date for better display
  static String formatDueDate(String dueDate) {
    if (dueDate.isEmpty) {
      return 'No due date';
    }

    try {
      final DateTime date = DateTime.parse(dueDate);
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('MMM d, yyyy');

      // Calculate days difference
      final int daysDifference = date.difference(now).inDays;

      if (daysDifference < 0) {
        return 'Overdue by ${-daysDifference} days';
      } else if (daysDifference == 0) {
        return 'Due today';
      } else if (daysDifference == 1) {
        return 'Due tomorrow';
      } else if (daysDifference < 7) {
        return 'Due in $daysDifference days';
      } else {
        // Use intl formatter for more consistent date formatting
        return 'Due on ${formatter.format(date)}';
      }
    } catch (e) {
      // If date parsing fails, return original
      return 'Due: $dueDate';
    }
  }

  // Utility method to create a transparent color without using withOpacity
  static Color getTransparentColor(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
