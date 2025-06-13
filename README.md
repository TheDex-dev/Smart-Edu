# Smart Edu

Smart Edu is a comprehensive education management application designed to help students organize their assignments, track deadlines, and manage their academic responsibilities efficiently.

## Features

### Authentication
- Login functionality with email and password
- Secure authentication flow
- User profile management

### Assignment Management
- View all assignments with their status (completed/pending)
- Add new assignments with details like title, subject, due date, and description
- Mark assignments as complete or incomplete
- View detailed information about each assignment

### Profile Management
- View and edit user profile information
- Track academic progress
- Access settings and preferences

### Settings
- Customize app appearance with dark mode toggle
- Manage notification preferences
- Language selection
- Account management options

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Demo Credentials

For testing purposes, you can use any email that contains '@' and any password with at least 6 characters.

## Dependencies

- flutter
- intl: For date formatting
- shared_preferences: For local storage

## Project Structure

- `lib/main.dart`: Entry point of the application
- `lib/models/`: Data models for assignments and authentication
- `lib/screens/`: UI screens for different features

## Future Enhancements

- Cloud synchronization
- Calendar integration
- Advanced notification system
- Teacher/parent portal
- Grade tracking
- Course management

## Getting Started

This project is built with Flutter and Dart. To run SmartEdu on your local machine:

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/smart_edu.git
   cd smart_edu
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Useful Resources

- [Flutter: Write Your First App](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

## Team

- **Titan** – Project Lead & UI/UX Design
- **Troy** – Backend Integration & API Development
- **Dewi** – Frontend Development & State Management
- **Luqman** – Database Design & Local Storage
- **Amri** – Testing & Quality Assurance

## Firebase Configuration

Smart Edu uses Firebase as its backend service. The following Firebase services are configured:

### Firebase Authentication
- Email/Password authentication
- Google Sign-In
- User profile management

### Cloud Firestore
- NoSQL database for storing user data and assignments
- Real-time updates for assignment status
- Offline persistence for data access without internet

### Firebase Analytics
- Track user engagement and app usage
- Monitor feature popularity
- Analyze user behavior

### Firebase Crashlytics
- Real-time crash reporting
- Error tracking and analysis
- Stability monitoring

### Firebase Cloud Messaging
- Push notifications for assignment deadlines
- Important updates and reminders
- In-app messaging

### Firebase Performance Monitoring
- Track app performance metrics
- Monitor network requests
- Identify performance bottlenecks

### Firebase Storage
- Store and retrieve user files and assignment attachments
- Secure file access with authentication
- Efficient file management

## Setting Up Firebase

To set up Firebase for your own instance of Smart Edu:

1. Create a new Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add Android and iOS apps to your Firebase project
3. Download and place the configuration files:
   - `google-services.json` in `android/app/`
   - `GoogleService-Info.plist` in `ios/Runner/`
4. Update the `firebase_options.dart` file with your project's configuration
5. Deploy Firestore security rules using `firebase deploy --only firestore:rules`
6. Deploy Storage security rules using `firebase deploy --only storage:rules`

For more detailed instructions, refer to the [Firebase documentation](https://firebase.google.com/docs/flutter/setup).

---

*SmartEdu © 2025 College Project*

