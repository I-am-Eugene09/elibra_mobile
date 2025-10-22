import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class ApiService {
    //Login
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
          'message': 'Forbidden.',
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
  required String firstName,
  required String lastName,
  required String sex,
  int? campusId,
  required String idnumber,
  required String email,
  required String role,
  required int patronType,
  required String password,
  required String passwordConfirmation,
  String? organization,
}) async {
  try {
    final Map<String, dynamic> payload = {
      'first_name': firstName,
      'last_name': lastName,
      'middle_initial': '',
      'sex': sex,
      'role': role,
      'email': email,
      'id_number': idnumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'patron_type_id': patronType,
    };

    // Only include campusId for non-Guests
    if (patronType != 3 && campusId != null) {
      payload['campus'] = campusId;
    }

    // Only include organization for Guests
    if (patronType == 3 && organization != null) {
      payload['external_organization'] = organization;
    }

    final response = await http.post(
      Uri.parse(Api.path('/auth/register')),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

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
    required String code,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(Api.path('/auth/verify-patron')),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            'otp': otp,
            'code': code,
           }
        ),
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

  //Send OTP
  static Future<Map<String, dynamic>> sendOTP(String email, String token) async {
  try {
    final res = await http.get(
      Uri.parse(Api.path('/auth/send-otp')),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      // body: jsonEncode({'email': email}),
    );

    if (res.statusCode == 200) {
      return {'error': false, 'data': jsonDecode(res.body)};
    }

    final body = jsonDecode(res.body);
    return {
      'error': true,
      'message': body['message'] ?? 'Failed to send OTP',
      'status': res.statusCode,
    };
  } catch (e) {
    return {'error': true, 'message': 'Network error: $e'};
  }
}

}
