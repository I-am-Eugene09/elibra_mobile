import 'package:elibra_mobile/services/config_auth.dart';
import 'package:flutter/material.dart';
import 'package:elibra_mobile/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';
import 'package:elibra_mobile/authentication/patron_signup.dart'; 

class PatronLoginPage extends StatefulWidget {
  const PatronLoginPage({super.key});

  @override
  State<PatronLoginPage> createState() => _PatronLoginPageState();
}

class _PatronLoginPageState extends State<PatronLoginPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  late TapGestureRecognizer _signUpTap;

  // CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                final result = await ApiService.login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                                if (!result['error']) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result['message'] ?? 'Login failed'),
                                    ),
                                  );
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
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
