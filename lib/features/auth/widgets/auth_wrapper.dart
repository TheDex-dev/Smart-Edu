import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../../../../core/services/firebase_service.dart';
import '../screens/login_screen.dart';
import '../../../main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // For desktop platforms, skip auth and go directly to main screen
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return const MainScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading indicator while determining auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show login screen if user is not authenticated
        if (snapshot.data == null) {
          return const LoginScreen();
        }

        // Show main app if user is authenticated
        return const MainScreen();
      },
    );
  }
}
