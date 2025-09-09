import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.11.1:8000';

  // Get Campuses
  static Future<Map<String, dynamic>> getCampuses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/all-c'),
        headers: {
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
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error: $e',
      };
    }
  }

  //Login User 
static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'user': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'error': false,
        'data': data,
      };
    } else {
      final body = jsonDecode(response.body);
      return {
        'error': true,
        'message': body['message'] ?? 'Login failed',
        'errors': body['errors'] ?? {},
      };
    }
  } catch (e) {
    return {
      'error': true,
      'message': 'Error: $e',
    };
  }
}


  // Register User
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required int sex, // 0 for Male, 1 for Female
    required int campusId,
    required int role, // 1 for Admin, 2 for Student
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        // Adjust to your actual Laravel route; assumes it's namespaced under /api
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'sex': sex,
          'campus_id': campusId,
          'role': role,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'error': false,
          'data': jsonDecode(response.body),
        };
      } else {
        final body = jsonDecode(response.body);
        return {
          'error': true,
          'message': body['message'] ?? 'Registration failed',
          'errors': body['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error: $e',
      };
    }
  }

  // Example: Send OTP
  static Future<Map<String, dynamic>> sendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'error': false,
          'data': jsonDecode(response.body),
        };
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyOTP({
  required String token,
  required String otp,
}) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-email'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'otp': otp}),
    );
    if (res.statusCode == 200) {
      return {'error': false, 'data': jsonDecode(res.body)};
    }
    final body = jsonDecode(res.body);
    return {'error': true, 'message': body['message'] ?? 'Failed', 'status': res.statusCode};
  } catch (e) {
    return {'error': true, 'message': 'Network error: $e'};
  }
}
}