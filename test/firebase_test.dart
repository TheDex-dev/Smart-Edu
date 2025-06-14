import 'package:flutter_test/flutter_test.dart';
import 'package:smart_edu/core/services/firebase_service.dart';
import 'package:smart_edu/core/config/firebase_options.dart';

void main() {
  group('Firebase Configuration Tests', () {
    test('Firebase options should be configured for Android', () {
      final androidOptions = DefaultFirebaseOptions.android;
      
      expect(androidOptions.projectId, 'smartedu-48462');
      expect(androidOptions.appId, '1:387403274966:android:81639752ff4d91d13c0777');
      expect(androidOptions.apiKey, 'AIzaSyAjnXWs88nJmmRiSJZvUIM7KiFDyss8ea8');
      expect(androidOptions.messagingSenderId, '387403274966');
      expect(androidOptions.storageBucket, 'smartedu-48462.firebasestorage.app');
    });

    test('Firebase service should be available', () {
      expect(FirebaseService.isFirebaseSupported, isTrue);
    });
  });
}
