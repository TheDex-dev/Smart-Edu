import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/performance_config.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({super.key, required this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, PerformanceOptimizedMixin {
  bool _showChild = false;

  @override
  void initState() {
    super.initState();

    // Start performance timer
    PerformanceMonitor.startTimer('splash_screen');

    // Use optimized duration
    final splashDuration = PerformanceConfig.getAnimationDuration(
      const Duration(milliseconds: 2000),
    );

    // Delay showing the main app to allow splash screen animation to complete
    Future.delayed(splashDuration, () {
      if (mounted) {
        PerformanceMonitor.endTimer('splash_screen', log: true);
        optimizedSetState(() {
          _showChild = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _showChild ? widget.child : _buildSplashScreen(),
    );
  }

  Widget _buildSplashScreen() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Material(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 60),
            ).animate().scale(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
            ),

            const SizedBox(height: 32),

            // App name text
            Text(
                  'Smart Edu',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                )
                .moveY(
                  begin: 20,
                  end: 0,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad,
                ),

            const SizedBox(height: 8),

            // Slogan text
            Text(
              'Your educational companion',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 16,
              ),
            ).animate().fadeIn(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 700),
            ),
          ],
        ),
      ),
    );
  }
}
