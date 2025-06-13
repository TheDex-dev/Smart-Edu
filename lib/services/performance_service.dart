import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import '../utils/cache_manager.dart';

/// Comprehensive performance monitoring and analytics service
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _timers = {};
  final Map<String, List<Duration>> _metrics = {};
  final List<PerformanceEvent> _events = [];
  Timer? _reportingTimer;

  /// Initialize performance monitoring
  void initialize() {
    if (kDebugMode) {
      _startPeriodicReporting();
    }
  }

  /// Start timing an operation
  void startTimer(String name) {
    _timers[name] = DateTime.now();
  }

  /// End timing and record the duration
  Duration? endTimer(String name, {bool log = false}) {
    final start = _timers.remove(name);
    if (start != null) {
      final duration = DateTime.now().difference(start);
      _recordMetric(name, duration);

      if (log && kDebugMode) {
        debugPrint('⏱️ Performance [$name]: ${duration.inMilliseconds}ms');
      }

      return duration;
    }
    return null;
  }

  /// Record a custom performance metric
  void recordMetric(String name, Duration duration) {
    _recordMetric(name, duration);
  }

  /// Record a performance event
  void recordEvent(String name, Map<String, dynamic> data) {
    _events.add(
      PerformanceEvent(name: name, timestamp: DateTime.now(), data: data),
    );

    // Keep only last 1000 events to prevent memory leaks
    if (_events.length > 1000) {
      _events.removeRange(0, _events.length - 1000);
    }
  }

  /// Get performance statistics for a metric
  PerformanceStats? getStats(String metricName) {
    final durations = _metrics[metricName];
    if (durations == null || durations.isEmpty) return null;

    final milliseconds = durations.map((d) => d.inMilliseconds).toList();
    milliseconds.sort();

    return PerformanceStats(
      metricName: metricName,
      count: durations.length,
      average: milliseconds.reduce((a, b) => a + b) / milliseconds.length,
      min: milliseconds.first.toDouble(),
      max: milliseconds.last.toDouble(),
      median: _calculateMedian(milliseconds),
      p95: _calculatePercentile(milliseconds, 0.95),
      p99: _calculatePercentile(milliseconds, 0.99),
    );
  }

  /// Get all performance statistics
  Map<String, PerformanceStats> getAllStats() {
    final stats = <String, PerformanceStats>{};
    for (final key in _metrics.keys) {
      final stat = getStats(key);
      if (stat != null) {
        stats[key] = stat;
      }
    }
    return stats;
  }

  /// Monitor widget build performance
  void monitorWidgetBuild(String widgetName, VoidCallback buildFunction) {
    startTimer('widget_build_$widgetName');
    try {
      buildFunction();
    } finally {
      endTimer('widget_build_$widgetName');
    }
  }

  /// Monitor async operation performance
  Future<T> monitorAsyncOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    startTimer(operationName);
    try {
      final result = await operation();
      endTimer(operationName, log: true);
      return result;
    } catch (e) {
      endTimer(operationName);
      recordEvent('error', {'operation': operationName, 'error': e.toString()});
      rethrow;
    }
  }

  /// Monitor frame rendering performance
  void startFrameMonitoring() {
    if (kDebugMode) {
      WidgetsBinding.instance.addTimingsCallback(_onFrameTimings);
    }
  }

  /// Stop frame monitoring
  void stopFrameMonitoring() {
    if (kDebugMode) {
      WidgetsBinding.instance.removeTimingsCallback(_onFrameTimings);
    }
  }

  /// Generate performance report
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('📊 Performance Report');
    buffer.writeln('=' * 50);

    final stats = getAllStats();
    if (stats.isEmpty) {
      buffer.writeln('No performance data available.');
      return buffer.toString();
    }

    // Sort by average duration (slowest first)
    final sortedStats =
        stats.entries.toList()
          ..sort((a, b) => b.value.average.compareTo(a.value.average));

    for (final entry in sortedStats) {
      final stat = entry.value;
      buffer.writeln('${stat.metricName}:');
      buffer.writeln('  Count: ${stat.count}');
      buffer.writeln('  Average: ${stat.average.toStringAsFixed(2)}ms');
      buffer.writeln('  Min: ${stat.min.toStringAsFixed(2)}ms');
      buffer.writeln('  Max: ${stat.max.toStringAsFixed(2)}ms');
      buffer.writeln('  Median: ${stat.median.toStringAsFixed(2)}ms');
      buffer.writeln('  95th percentile: ${stat.p95.toStringAsFixed(2)}ms');
      buffer.writeln('  99th percentile: ${stat.p99.toStringAsFixed(2)}ms');
      buffer.writeln();
    }

    // Memory usage
    buffer.writeln('Memory Usage:');
    final cacheInfo = CacheManager.instance.getCacheInfo();
    buffer.writeln('  Cache entries: ${cacheInfo.toString()}');

    return buffer.toString();
  }

  /// Clear all performance data
  void clearData() {
    _timers.clear();
    _metrics.clear();
    _events.clear();
  }

  void _recordMetric(String name, Duration duration) {
    _metrics.putIfAbsent(name, () => []).add(duration);

    // Keep only last 1000 measurements per metric
    final list = _metrics[name]!;
    if (list.length > 1000) {
      list.removeRange(0, list.length - 1000);
    }
  }

  void _startPeriodicReporting() {
    _reportingTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (kDebugMode) {
        debugPrint(generateReport());
      }
    });
  }

  void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final buildDuration = timing.buildDuration;
      final rasterDuration = timing.rasterDuration;

      recordMetric('frame_build', buildDuration);
      recordMetric('frame_raster', rasterDuration);

      // Log slow frames
      const slowFrameThreshold = Duration(milliseconds: 16);
      if (buildDuration > slowFrameThreshold ||
          rasterDuration > slowFrameThreshold) {
        recordEvent('slow_frame', {
          'build_ms': buildDuration.inMilliseconds,
          'raster_ms': rasterDuration.inMilliseconds,
        });
      }
    }
  }

  double _calculateMedian(List<int> sortedValues) {
    final length = sortedValues.length;
    if (length % 2 == 0) {
      return (sortedValues[length ~/ 2 - 1] + sortedValues[length ~/ 2]) / 2.0;
    } else {
      return sortedValues[length ~/ 2].toDouble();
    }
  }

  double _calculatePercentile(List<int> sortedValues, double percentile) {
    final index = (sortedValues.length * percentile).ceil() - 1;
    return sortedValues[max(0, min(index, sortedValues.length - 1))].toDouble();
  }

  void dispose() {
    _reportingTimer?.cancel();
    stopFrameMonitoring();
  }
}

/// Performance statistics data class
class PerformanceStats {
  final String metricName;
  final int count;
  final double average;
  final double min;
  final double max;
  final double median;
  final double p95;
  final double p99;

  PerformanceStats({
    required this.metricName,
    required this.count,
    required this.average,
    required this.min,
    required this.max,
    required this.median,
    required this.p95,
    required this.p99,
  });

  @override
  String toString() {
    return 'PerformanceStats(name: $metricName, avg: ${average.toStringAsFixed(2)}ms, count: $count)';
  }
}

/// Performance event data class
class PerformanceEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  PerformanceEvent({
    required this.name,
    required this.timestamp,
    required this.data,
  });
}

/// Mixin for easy performance monitoring in widgets
mixin PerformanceMonitorMixin {
  final PerformanceService _performance = PerformanceService();

  void startTimer(String name) => _performance.startTimer(name);
  Duration? endTimer(String name, {bool log = false}) =>
      _performance.endTimer(name, log: log);

  void recordEvent(String name, Map<String, dynamic> data) =>
      _performance.recordEvent(name, data);

  Future<T> monitorAsync<T>(String name, Future<T> Function() operation) =>
      _performance.monitorAsyncOperation(name, operation);
}
