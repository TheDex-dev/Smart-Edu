import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/assignments/screens/role_based_assignment_screen.dart';
import 'shared/screens/splash_screen.dart';
import 'core/utils/performance_config.dart';
import 'core/utils/cache_manager.dart';
import 'core/utils/app_helpers.dart';
import 'core/theme/modern_theme.dart';
import 'core/services/firebase_service.dart';
import 'core/services/performance_service.dart';
import 'features/auth/widgets/auth_wrapper.dart';

void main() async {
  // Catch any errors that occur during initialization
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase (handles platform detection internally)
    await FirebaseService.initialize();

    // Set up Firebase Messaging handlers (only on supported platforms)
    await FirebaseService.setupMessageHandlers();

    // Initialize cache manager
    await CacheManager.instance.initialize();

    // Initialize performance monitoring (only on supported platforms)
    PerformanceService().initialize();

    // Configure performance settings
    PerformanceConfig.configureApp();

    // Configure system UI for better integration with OS
    await PerformanceConfig.configureSystemUI();

    // Enable high refresh rate on supported Android devices
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (e) {
      // Ignore if not supported
      ErrorUtils.handleError(e, context: 'High refresh rate setup');
    }

    // Run the app in a zone that catches all errors
    runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    // Log fatal errors during initialization
    ErrorUtils.handleError(
      e,
      stack: stack,
      context: 'App initialization',
      fatal: true,
    );

    // Show a basic error screen if we can't even initialize
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to initialize app: $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This might be due to platform compatibility issues.\nTrying to continue with limited functionality...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Try to run the app anyway with minimal setup
                    runApp(
                      MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (_) => ThemeProvider(),
                          ),
                        ],
                        child: const MyApp(),
                      ),
                    );
                  },
                  child: const Text('Continue Anyway'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize theme from saved preferences
  Future<void> initializeTheme() async {
    if (_isInitialized) return;

    try {
      final savedTheme = await CacheManager.instance.getCachedData<String>(
        CacheKeys.themes,
      );
      if (savedTheme != null) {
        _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Theme initialization');
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save theme preference
    try {
      await CacheManager.instance.cacheData(
        CacheKeys.themes,
        _themeMode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (e) {
      ErrorUtils.handleError(e, context: 'Theme saving');
    }

    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeProvider>(context, listen: false).initializeTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Smart Edu',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ModernTheme.lightTheme,
      darkTheme: ModernTheme.darkTheme,
      home: const SplashScreen(child: AuthWrapper()),
      // Add error handling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
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

  // Animation transitions
  late final Animatable<Offset> _screenTransitionOffset;

  // Screens for better performance - pre-constructed
  final List<Widget> _screens = [const RoleBasedAssignmentScreen(), const ProfileScreen()];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize animation tweens with curves for better visual appeal
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
    // Animate between tabs
    if (_selectedIndex != index) {
      _animationController.reset();
      _animationController.forward();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(primaryColor),
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
      child: _screens[_selectedIndex],
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Assignments',
              tooltip: 'View your assignments',
            ),
            BottomNavigationBarItem(
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
}
