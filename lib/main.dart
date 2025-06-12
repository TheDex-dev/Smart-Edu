import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'screens/profile_screen.dart';
import 'screens/assignment_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_assignment_screen.dart';
import 'screens/splash_screen.dart';
import 'models/auth.dart';
import 'utils/performance_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure performance settings
  PerformanceConfig.configureApp();

  // Configure system UI for better integration with OS
  await PerformanceConfig.configureSystemUI();

  // Enable high refresh rate on supported Android devices
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    // Ignore if not supported
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Smart Edu',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: SplashScreen(
        child: Auth.isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
        primary: Colors.deepPurple,
        secondary: Colors.deepPurpleAccent,
        tertiary: Colors.teal,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        displayMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.poppins(fontSize: 16),
        bodyMedium: GoogleFonts.poppins(fontSize: 14),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: baseTheme.colorScheme.inversePrimary,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: baseTheme.colorScheme.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: baseTheme.colorScheme.secondary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: baseTheme.colorScheme.primary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: baseTheme.colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
        primary: Colors.deepPurpleAccent,
        secondary: Colors.deepPurple,
        tertiary: Colors.tealAccent,
      ),
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        displayMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.poppins(fontSize: 16),
        bodyMedium: GoogleFonts.poppins(fontSize: 14),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E1E1E),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF1E1E1E),
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: baseTheme.colorScheme.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: baseTheme.colorScheme.secondary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade300,
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: baseTheme.colorScheme.primary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: baseTheme.colorScheme.primary,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
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

  // Animation transitions
  late final Animatable<Offset> _settingsRouteOffset;
  late final Animatable<Offset> _addAssignmentRouteOffset;
  late final Animatable<Offset> _screenTransitionOffset;

  // Cached screens for better performance - pre-constructed
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

    // Initialize animation tweens with curves for better visual appeal
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
    ).chain(CurveTween(curve: Curves.easeOutCubic));

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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Assignments',
              tooltip: 'View your assignments',
            ),
            BottomNavigationBarItem(
              icon: _buildAddButton(primaryColor),
              label: '',
              tooltip: 'Add new assignment',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shelves),
              label: 'Library',
              tooltip: 'Access library resources',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              tooltip: 'View your profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildAddButton(Color primaryColor) {
    // Use precalculated values for better performance
    const double startScale = 1.0;
    const double endScale = 1.2;
    const double iconSize = 40;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: startScale, end: endScale),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        );
      },
    );
  }
}
