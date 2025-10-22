  import 'dart:convert';
  import 'package:elibra_mobile/services/config_auth.dart';
  import 'package:elibra_mobile/services/user_services.dart';
  import 'package:flutter/material.dart';
  import 'package:elibra_mobile/assets.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:flutter/gestures.dart';
  import 'package:elibra_mobile/authentication/patron_signup.dart';
  import 'package:elibra_mobile/loading.dart';
  import 'package:elibra_mobile/no_internet.dart';
  import 'package:elibra_mobile/validations.dart';
  import 'package:elibra_mobile/authentication/users.dart';
  import 'package:elibra_mobile/authentication/otp.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class PatronLoginPage extends StatefulWidget {
    const PatronLoginPage({super.key});

    @override
    State<PatronLoginPage> createState() => _PatronLoginPageState();
  }

  class _PatronLoginPageState extends State<PatronLoginPage> {
    late TapGestureRecognizer _signUpTap;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool _isPasswordVisible = false;

    // Validation trackers
    bool _emailEmpty = false;
    bool _passwordEmpty = false;

    String _welcomeName = "ISUdyante";

    @override
    void initState() {
      super.initState();
      _loadFirstName();

      _signUpTap = TapGestureRecognizer()
        ..onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountTypeSelectionPage(),
            ),
          );
        };
    }

    @override
    void dispose() {
      _signUpTap.dispose();
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

  Future<void> _loadFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('flutter.first_name');

    if (name == null || name.isEmpty || name == "ISUdyante") {
      final userDataString = prefs.getString('flutter.user_data');

      if (userDataString != null && userDataString.isNotEmpty) {
        try { 
          final userData = jsonDecode(userDataString);
          name = userData['first_name'] ?? "ISUdyante";

          // Update local storage
          await prefs.setString('flutter.first_name', name ?? 'No name Fetched');
        } catch (e) {
          debugPrint('Error decoding user_data: $e');
        }
      }
    }

    setState(() {
      _welcomeName = name ?? "ISUdyante";
    });

  }

    Future<void> _handleLogin() async {
      setState(() {
        _emailEmpty = emailController.text.trim().isEmpty;
        _passwordEmpty = passwordController.text.trim().isEmpty;
      });

      if (_emailEmpty || _passwordEmpty) {
        ValidationDialogs.emptyField(context);
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CustomLoadingModal(message: "Logging in..."),
      );

      final result = await ApiService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.of(context).pop();

      if (result['noInternet'] == true) {
        showDialog(
          context: context,
          builder: (_) => const NoInternetModal(),
        );
        return;
      }

      if (!result['error']) {
        final token = result['token'];
          if (token != null) await UserService.saveToken(token);

          // Fetch profile data right after login
          final profileResponse = await UserService.fetchUserProfile();
          if (profileResponse != null) {
            final prefs = await SharedPreferences.getInstance();
            // await prefs.setString('flutter.user_data', jsonEncode(profileResponse));
            await prefs.setString('flutter.first_name', profileResponse['first_name'] ?? 'ISUdyante');

          }

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        String msg = result['message'];

        if (msg.contains("Invalid Credentials.")) {
          ValidationDialogs.invalidCredentials(context);
          return;
        }

        if (msg.contains("Forbidden.")) {
          ValidationDialogs.pendingApproval(context);
          return;
        }

        ValidationDialogs.genericError(context);
      }
    }

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      double maxFormWidth = screenWidth < 600 ? screenWidth * 0.9 : 500;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxFormWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppImages.logo,
                          height: screenWidth < 600 ? 60 : 80,
                          width: screenWidth < 600 ? 60 : 80,
                        ),
                        const SizedBox(width: 14),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'E-Libra',
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: screenWidth < 600 ? 24 : 32,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enhanced Integrated Library & Resource \nAutomation System',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: screenWidth < 600 ? 12 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Greeting
                    Text(
                      'Welcome Back, \n$_welcomeName!',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: screenWidth < 600 ? 24 : 32,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Login Form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email Field
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email or ID Number',
                              labelStyle: TextStyle(
                                color: _emailEmpty
                                    ? AppColors.primaryRed
                                    : AppColors.textColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _emailEmpty
                                      ? AppColors.primaryRed
                                      : AppColors.textColor,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _emailEmpty
                                      ? AppColors.primaryRed
                                      : AppColors.primaryGreen,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (_) {
                              if (_emailEmpty) setState(() => _emailEmpty = false);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: _passwordEmpty
                                    ? AppColors.primaryRed
                                    : AppColors.textColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _passwordEmpty
                                      ? AppColors.primaryRed
                                      : AppColors.textColor,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _passwordEmpty
                                      ? AppColors.primaryRed
                                      : AppColors.primaryGreen,
                                  width: 2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            onChanged: (_) {
                              if (_passwordEmpty)
                                setState(() => _passwordEmpty = false);
                            },
                          ),
                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login Button
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: AppTextStyles.button.copyWith(
                                fontSize: screenWidth < 600 ? 16 : 18,
                                color: AppColors.backgroundColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Signup Text
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account yet? ",
                                style: AppTextStyles.body.copyWith(
                                  fontSize: screenWidth < 600 ? 12 : 14,
                                  color: AppColors.textColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign up",
                                    style: AppTextStyles.link,
                                    recognizer: _signUpTap,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
