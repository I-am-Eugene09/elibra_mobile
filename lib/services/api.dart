import 'package:flutter/foundation.dart';

class Api {
  static const String baseUrl = 'http://192.168.1.148:8000/api';
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String imageUrl = "http://192.168.1.148:8000/";
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
