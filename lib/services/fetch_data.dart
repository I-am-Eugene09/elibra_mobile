import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import '../models/user_model.dart';
import 'api.dart';

class FetchDataService {
  // Get Campuses
  static Future<Map<String, dynamic>> getCampuses() async {
    try {
      final url = Api.path('/all-c');
      Api.debugLog('GET $url');
      final response = await http.get(
        Uri.parse(url),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'error': false,
          'data': List<Map<String, dynamic>>.from(data),
        };
      } else {
        return {
          'error': true,
          'message': 'Failed to fetch campuses',
          'status': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error: $e',
      };
    }
  }
}