import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class ApiService {
  // Login User 
  // static Future<Map<String, dynamic>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(Api.path('/auth/login')),
  //       headers: const {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'user': email,
  //         'password': password,
  //       }),
  //     );
  //     final body = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       // final data = jsonDecode(response.body);
  //       return {
  //         'error': false,
  //         'data': body,
  //         'token': body['access_token'],
  //       };
  //     } else if (response.statusCode == 403) {
  //       return {
  //         'error': true,
  //         'message': 'Your account is pending approval by the admin.',
  //       };
  //     } else {
  //       final body = jsonDecode(response.body);
  //       return {
  //         'error': true,
  //         'message': body['message'] ?? 'Login failed',
  //         'errors': body['errors'] ?? {},
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       'error': true,
  //       'message': 'Error: $e',
  //     };
  //   }
  // }
  static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(Api.path('/auth/login')),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'user': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 2));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'error': false,
          'data': body,
          'token': body['access_token'],
        };
      } else if (response.statusCode == 403) {
        return {
          'error': true,
          'message': 'Your account is pending approval by the admin.',
        };
      } else if (response.statusCode == 401) {
        return {
          'error': true,
          'message': 'Invalid Credentials.',
        };
      } else {
        return {
          'error': true,
          'message': body['message'] ?? 'Login failed',
          'errors': body['errors'] ?? {},
        };
      }
    } on http.ClientException catch (_) {
      return {'error': true, 'noInternet': true, 'message': 'Client Exception'};
    } on TimeoutException catch (_) {
      return {'error': true, 'noInternet': true, 'message': 'Request timed out'};
    } catch (e) {
      return {'error': true, 'message': 'Error: $e'};
    }
}

 static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String sex, // "0" or "1"
    required int campusId,
    String role = '2',
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Api.path('/auth/register')),
        headers: const {
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

      print("Register response [${response.statusCode}]: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'error': false,
          'data': body,
          'token': body['access_token'], 
        };
      } else {
        return {
          'error': true,
          'message': body['message'] ?? 'Registration failed',
          'errors': body['errors'] ?? {},
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

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOTP({
    required String token,
    required String otp,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(Api.path('/auth/verify-email')),
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
      return {
        'error': true,
        'message': body['message'] ?? 'Failed',
        'status': res.statusCode
      };
    } catch (e) {
      return {'error': true, 'message': 'Network error: $e'};
    }
  }
}
