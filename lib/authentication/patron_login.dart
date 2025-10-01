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

  // Track empty fields
  bool _emailEmpty = false;
  bool _passwordEmpty = false;

  @override
  void initState() {
    super.initState();
    _signUpTap = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatronSignUpPage()),
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
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      String msg = result['message'];
      // String err = result['status'];

    if (msg.contains("Invalid Credentials.")) {
      ValidationDialogs.invalidCredentials(context);
      return;
    }

    if(msg.contains("Forbidden")){
      ValidationDialogs.pendingApproval(context);
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
                  // Logo + App title
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

                  // Title
                  Text(
                    'Welcome \nBack!',
                    style: AppTextStyles.heading.copyWith(
                      fontSize: screenWidth < 600 ? 24 : 32,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGreen),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: _emailEmpty ? AppColors.primaryRed : AppColors.textColor),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _emailEmpty ? AppColors.primaryRed : AppColors.textColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _emailEmpty ? AppColors.primaryRed : AppColors.primaryGreen, width: 2),
                            ),
                          ),
                          onChanged: (_) {
                            if (_emailEmpty) setState(() => _emailEmpty = false);
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: _passwordEmpty ? AppColors.primaryRed : AppColors.textColor),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _passwordEmpty ? AppColors.primaryRed : AppColors.textColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _passwordEmpty ? AppColors.primaryRed : AppColors.primaryGreen, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                            if (_passwordEmpty) setState(() => _passwordEmpty = false);
                          },
                        ),

                        const SizedBox(height: 12),

                        // Forgot Password
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
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

                        // Sign Up Link
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
