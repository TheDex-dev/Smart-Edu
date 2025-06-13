import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Advanced cache management for Smart Edu app
class CacheManager {
  static CacheManager? _instance;
  static CacheManager get instance => _instance ??= CacheManager._();

  CacheManager._();

  SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, Timer> _expirationTimers = {};

  /// Initialize cache manager
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Cache data with expiration
  Future<void> cacheData(
    String key,
    dynamic data, {
    Duration? expiration,
    bool useMemoryCache = true,
  }) async {
    await initialize();

    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };

    // Store in memory cache
    if (useMemoryCache) {
      _memoryCache[key] = cacheEntry;

      // Set expiration timer
      if (expiration != null) {
        _expirationTimers[key]?.cancel();
        _expirationTimers[key] = Timer(expiration, () {
          _memoryCache.remove(key);
          _expirationTimers.remove(key);
        });
      }
    }

    // Store in persistent cache
    try {
      await _prefs!.setString(key, jsonEncode(cacheEntry));
    } catch (e) {
      if (kDebugMode) {
        print('Cache storage error: $e');
      }
    }
  }

  /// Retrieve cached data
  Future<T?> getCachedData<T>(String key) async {
    await initialize();

    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      final entry = _memoryCache[key];
      if (_isEntryValid(entry)) {
        return entry['data'] as T?;
      } else {
        _memoryCache.remove(key);
      }
    }

    // Check persistent cache
    try {
      final cachedString = _prefs!.getString(key);
      if (cachedString != null) {
        final entry = jsonDecode(cachedString);
        if (_isEntryValid(entry)) {
          // Restore to memory cache
          _memoryCache[key] = entry;
          return entry['data'] as T?;
        } else {
          // Remove expired entry
          await _prefs!.remove(key);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Cache retrieval error: $e');
      }
    }

    return null;
  }

  /// Check if cached data exists and is valid
  Future<bool> isCached(String key) async {
    final data = await getCachedData(key);
    return data != null;
  }

  /// Clear specific cache entry
  Future<void> clearCache(String key) async {
    await initialize();
    _memoryCache.remove(key);
    _expirationTimers[key]?.cancel();
    _expirationTimers.remove(key);
    await _prefs!.remove(key);
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    await initialize();
    _memoryCache.clear();
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    _expirationTimers.clear();
    await _prefs!.clear();
  }

  /// Get cache size information
  Future<Map<String, int>> getCacheInfo() async {
    await initialize();
    final keys = _prefs!.getKeys();
    return {
      'memoryEntries': _memoryCache.length,
      'persistentEntries': keys.length,
      'totalEntries': _memoryCache.length + keys.length,
    };
  }

  bool _isEntryValid(Map<String, dynamic> entry) {
    final timestamp = entry['timestamp'] as int?;
    final expiration = entry['expiration'] as int?;

    if (timestamp == null) return false;
    if (expiration == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    return now - timestamp < expiration;
  }
}

/// Cache keys for different data types
class CacheKeys {
  static const String userProfile = 'user_profile';
  static const String assignments = 'assignments';
  static const String settings = 'app_settings';
  static const String themes = 'theme_settings';
  static const String notifications = 'notification_settings';

  // Generate cache key for user-specific data
  static String userSpecific(String userId, String dataType) {
    return '${userId}_$dataType';
  }

  // Generate cache key for date-specific data
  static String dateSpecific(String dataType, DateTime date) {
    return '${dataType}_${date.millisecondsSinceEpoch}';
  }
}

/// Mixin for widgets that use caching
mixin CacheMixin {
  final CacheManager _cache = CacheManager.instance;

  Future<T?> getCached<T>(String key) => _cache.getCachedData<T>(key);

  Future<void> setCached(String key, dynamic data, {Duration? expiration}) =>
      _cache.cacheData(key, data, expiration: expiration);

  Future<void> clearCached(String key) => _cache.clearCache(key);
}
