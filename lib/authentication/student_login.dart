import 'package:flutter/material.dart';
import 'package:elibra_mobile/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';

import 'package:elibra_mobile/authentication/student_signup.dart'; //signup file patch



class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  bool _isPasswordVisible = false;
  late TapGestureRecognizer _signUpTap;

  @override
  void initState() {
    super.initState();
    _signUpTap = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentSignUpPage()),
        );
      };
  }

  @override
  void dispose() {
    _signUpTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Limit form width on large screens (tablet/PC)
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
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextField(
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
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ElevatedButton(
                            onPressed: () {
                               Navigator.pushReplacementNamed(context, '/home');
                            },
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
