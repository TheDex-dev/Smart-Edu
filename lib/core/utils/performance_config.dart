import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

/// Performance configuration and optimization utilities for Smart Edu app
class PerformanceConfig {
  PerformanceConfig._();

  /// Enable optimizations for debug vs release builds
  static bool get isOptimized => kReleaseMode;

  /// Animation duration multiplier (faster in release mode)
  static double get animationScale => isOptimized ? 0.8 : 1.0;

  /// Cache sizes for images and other resources
  static const int imageCacheSize = 100; // Maximum cached images
  static const int maxImageCacheSize = 200 * 1024 * 1024; // 200MB

  /// List performance settings
  static const int listCacheExtent = 500; // ListView cache extent
  static const int maxListItems = 1000; // Maximum items before pagination

  /// Memory optimization settings
  static void configureApp() {
    if (isOptimized) {
      // Reduce animation duration in release mode
      timeDilation = 0.5;

      // Configure image cache
      PaintingBinding.instance.imageCache.maximumSize = imageCacheSize;
      PaintingBinding.instance.imageCache.maximumSizeBytes = maxImageCacheSize;
    }
  }

  /// Get optimized animation duration
  static Duration getAnimationDuration(Duration base) {
    return Duration(
      milliseconds: (base.inMilliseconds * animationScale).round(),
    );
  }

  /// Configure system UI for performance
  static Future<void> configureSystemUI() async {
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Configure system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Memory pressure handling
  static void handleMemoryPressure() {
    // Clear image cache if memory pressure is high
    PaintingBinding.instance.imageCache.clear();

    // Clear live images
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Widget build optimization utilities
  static Widget optimizedBuilder({
    required Widget child,
    bool addRepaintBoundary = true,
    bool addAutomaticKeepAlive = false,
  }) {
    Widget result = child;

    if (addRepaintBoundary) {
      result = RepaintBoundary(child: result);
    }

    if (addAutomaticKeepAlive) {
      result = AutomaticKeepAlive(child: result);
    }

    return result;
  }
}

/// Mixin for performance-optimized stateful widgets
mixin PerformanceOptimizedMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    // Configure any widget-specific optimizations
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  /// Optimized setState that debounces rapid updates
  void optimizedSetState(
    VoidCallback fn, {
    Duration debounce = const Duration(milliseconds: 16),
  }) {
    if (mounted) {
      setState(fn);
    }
  }
}

/// Performance monitoring utilities
class PerformanceMonitor {
  static final Map<String, DateTime> _timers = {};

  /// Start timing an operation
  static void startTimer(String name) {
    _timers[name] = DateTime.now();
  }

  /// End timing and optionally log results
  static Duration? endTimer(String name, {bool log = false}) {
    final start = _timers.remove(name);
    if (start != null) {
      final duration = DateTime.now().difference(start);
      if (log && kDebugMode) {
        debugPrint('Performance [$name]: ${duration.inMilliseconds}ms');
      }
      return duration;
    }
    return null;
  }
}
