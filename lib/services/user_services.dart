//USER SERVICE
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/user_model.dart';
import 'api.dart';

class UserService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  // Save user data to local storage
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get user data from local storage
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    
    if (userString != null) {
      try {
        final userJson = jsonDecode(userString);
        return User.fromJson(userJson);
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  // Save auth token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // Fetch user profile from API
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'error': true,
          'message': 'No authentication token found',
        };
      }
      final response = await http.get(
        Uri.parse(Api.path('/user')),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Fetch user profile request timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
        
      } else {
        return {
          'error': true,
          'message': 'Failed to fetch user profile',
          'status': response.statusCode,
        };
      }
    } catch (e) {
      print('UserService: Profile fetch error: $e');
      return {
        'error': true,
        'message': 'Error: $e',
      };
    }
  }

static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? middleInitial,
    String? email,
    String? contactNumber,
    // String? address,
    String? sex, 
    File? avatar,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'error': true, 'message': 'No token found'};

      final uri = Uri.parse(Api.path('/me/update'));
      final request = http.MultipartRequest("POST", uri);
      // request.fields['_method'] = 'PUT';
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (firstName != null) request.fields['first_name'] = firstName;
      if (lastName != null) request.fields['last_name'] = lastName;
      if (middleInitial != null) request.fields['middle_initial'] = middleInitial;
      if (email != null) request.fields['email'] = email;
      if (contactNumber != null) request.fields['contact_number'] = contactNumber;
      // if (address != null) request.fields['address'] = address;
      if (sex != null) request.fields['sex'] = sex;

      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_picture', avatar.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);
        
        if (data['status'] == 'success' && data['user'] != null) {
          await saveUser(User.fromJson(data['user']));
        }
        return {'error': false, ...data};
      } else if (response.statusCode == 422) {
        final body = jsonDecode(response.body);
        return {
          'error': true,
          'message': body['message'] ?? 'Validation error',
          'errors': body['errors'] ?? {},
        };
      } else {
        return {
          'error': true,
          'message': response.body,
          'status': response.statusCode,
        };
      }
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  static Future<bool> isLoggedIn() async {
  return await checkAuth();
}


  //check if authorized
  static Future<bool> checkAuth() async {
    final token = await getToken();

    if(token == null) return false;

    try{
      final res = await http.get(
        Uri.parse(Api.path('/user')),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      );

      if(res.statusCode != 200){
        return true;
      }else{
        return false;
      }

    }catch(e){
      return false;
    }
  }

      // Login and save user data
      static Future<Map<String, dynamic>> loginAndSaveUser({
        required String email,
        required String password,
      }) async {
        try {
          print('UserService: Attempting login for email: $email');
          final response = await http.post(
            Uri.parse(Api.path('/auth/login')),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'user': email,
              'password': password,
            }),
          ).timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Login request timeout');
            },
          );

          print('UserService: Login response status: ${response.statusCode}');
          print('UserService: Login response body: ${response.body}');

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final token = data['token'] ?? data['access_token'];
            
            print('UserService: Token found: ${token != null ? 'Yes' : 'No'}');
            
            if (token != null) {
              await saveToken(token);
              print('UserService: Token saved successfully');
              
              try {
                print('UserService: Attempting to create user from login response...');
                if (data['user'] != null) {
                  final user = User.fromJson(data['user']);
                  await saveUser(user);
                  print('UserService: User created from login response successfully');
                  
                  return {
                    'error': false,
                    'data': data,
                    'user': user,
                  };
                }
              } catch (userError) {
                print('UserService: Could not create user from login response: $userError');
              }

              // Try to fetch user profile as fallback
              try {
                print('UserService: Attempting to fetch user profile...');
                final profileResult = await fetchUserProfile();
                if (!profileResult['error'] && profileResult['data'] != null) {
                  final user = User.fromJson(profileResult['data']);
                  await saveUser(user);
                  print('UserService: User profile saved successfully');
                  
                  return {
                    'error': false,
                    'data': data,
                    'user': user,
                  };
                  
                } else {
                  print('UserService: Profile fetch failed: ${profileResult['message']}');
                }
              } catch (profileError) {
                print('UserService: Profile fetch error: $profileError');
                // Continue with login even if profile fetch fails
              }
            }
            
            return {
              'error': false,
              'data': data,
            };
          } else if (response.statusCode == 403) {
            return {
              'error': true,
              'message': 'Your account is pending approval by the admin.',
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
          print('UserService: Login error: $e');
          return {
            'error': true,
            'message': 'Error: $e',
          };
        }
      }

  // Logout 
static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  String? firstName = prefs.getString('flutter.first_name');
  final token = prefs.getString(_tokenKey);

   await prefs.clear();

   if (firstName != null) {
    await prefs.setString('flutter.first_name', firstName);
  }

  // 2. Fire & forget server logout
  if (token != null) {
    try {
      http.post(
        Uri.parse(Api.path('/auth/logout')),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint('Logout request failed: $e');
    }
  }
}



}
