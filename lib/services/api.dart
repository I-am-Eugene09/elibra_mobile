import 'package:flutter/foundation.dart';

class Api {
  // Centralized base URL for all API calls
  static const String baseUrl = 'http://192.168.56.1:8000/api';

  // Helper to build full endpoints
  static String path(String relativePath) => '$baseUrl$relativePath';

  // Optional: log URLs in debug
  static void debugLog(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[API] $message');
    }
  }
}
