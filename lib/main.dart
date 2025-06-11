import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/assignment_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_assignment_screen.dart';
import 'models/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Edu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
        cardTheme: const CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: Auth.isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fabAnimation;

  // Cache for animations
  late final Animatable<Offset> _settingsRouteOffset;
  late final Animatable<Offset> _addAssignmentRouteOffset;
  late final Animatable<Offset> _screenTransitionOffset;

  // Cached screens for better performance
  static const List<Widget> _screens = [
    AssignmentScreen(),
    SizedBox(), // Placeholder for add button
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Initialize animation tweens
    _settingsRouteOffset = Tween<Offset>(
      begin: const Offset(0.2, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut));

    _addAssignmentRouteOffset = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOutQuart));

    _screenTransitionOffset = Tween<Offset>(
      begin: const Offset(0.05, 0.0),
      end: Offset.zero,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // If center button is tapped, open add assignment screen
    if (index == 1) {
      _openAddAssignmentScreen();
      return;
    }

    // Animate between tabs
    if (_selectedIndex != index) {
      _animationController.reset();
      _animationController.forward();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _openAddAssignmentScreen() {
    _animationController.reverse().then((_) {
      _animationController.forward();
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                AddAssignmentScreen(onAssignmentAdded: _handleNewAssignment),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(_addAssignmentRouteOffset),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _handleNewAssignment(Map<String, dynamic> assignment) {
    // Callback to add the assignment to the main list
    // This is handled in the AssignmentScreen, so we can
    // use this to navigate back to the assignments tab
    setState(() {
      _selectedIndex = 0; // Navigate to assignments tab
    });
    // Return to home screen
    Navigator.pop(context);
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: animation.drive(_settingsRouteOffset),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: _buildAppBar(primaryColor),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(primaryColor),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primaryColor) {
    return AppBar(
      title: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(opacity: _fabAnimation, child: child);
        },
        child: const Text('Smart Edu'),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _navigateToSettings,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(_screenTransitionOffset),
            child: child,
          ),
        );
      },
      child:
          _selectedIndex == 1
              ? const SizedBox()
              : _screens[_selectedIndex > 1
                  ? _selectedIndex - 1
                  : _selectedIndex],
    );
  }

  Widget _buildBottomNavigationBar(Color primaryColor) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Assignments',
        ),
        BottomNavigationBarItem(icon: _buildAddButton(primaryColor), label: ''),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shelves),
          label: 'Assignments',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      elevation: 8,
    );
  }

  Widget _buildAddButton(Color primaryColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 1.2),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(Icons.add_circle, size: 40, color: primaryColor),
        );
      },
    );
  }
}
