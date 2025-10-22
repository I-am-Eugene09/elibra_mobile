import 'package:elibra_mobile/assets.dart';
import 'package:elibra_mobile/authentication/patron_login.dart';
import 'package:elibra_mobile/services/config_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elibra_mobile/authentication/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elibra_mobile/loading.dart';

class AccountVerificationPage extends StatelessWidget {
  final String email;
  final String token;

  const AccountVerificationPage({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Logo and title
                    Column(
                      children: [
                        SvgPicture.asset(
                          AppImages.logo,
                          height: 90,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'E-Libra',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Enhanced Integrated Library & Resource\nAutomation System',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Verify Account title
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Verify ',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: 'Account',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Buttons
                    Row(
                      children: [
                        // Skip Verification Button
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Title
                                          const Text(
                                            "Skip Verification?",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 12),
                                          Container(
                                            height: 2,
                                            color: AppColors.primaryGreen,
                                          ),

                                          const SizedBox(height: 20),

                                          // Info Text
                                          const Text(
                                            "• Verifying your account gives you access to all the main features of E-Libra.\n\n"
                                            "• Don’t worry — you can verify your account later after logging in.",
                                            style: TextStyle(
                                              fontSize: 14,
                                              height: 1.4,
                                              color: AppColors.textColor,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),

                                          const SizedBox(height: 24),
                                          Container(
                                            height: 2,
                                            color: AppColors.primaryGreen,
                                          ),

                                          const SizedBox(height: 16),

                                          // Buttons Row
                                          Row(
                                            children: [
                                              // Cancel Button
                                              Expanded(
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    // Remove border outline
                                                    side: BorderSide.none,
                                                    backgroundColor: Colors.transparent,
                                                  ),
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              // Proceed Button
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.primaryGreen,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text(
                                                    "Proceed",
                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                if (confirm == true) {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('auth_token');
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PatronLoginPage()),
                                    (route) => false,
                                  );
                                }
                              },

                              child: const Text(
                                "Skip Verification",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Verify Now Button
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const CustomLoadingModal( message: "Sending OTP..."),
                                  );

                                try {
                                  final res = await ApiService.sendOTP(email, token);

                                  Navigator.pop(context);

                                  if (res['error'] == false) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OTPVerificationScreen(
                                          email: email,
                                          userToken: token,
                                          otpToken: res['data']['token'],
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to send OTP. Try again.')),
                                    );
                                  }
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('An unexpected error occurred.')),
                                  );
                                }
                              },
                              child: const Text(
                                "Verify Now!",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Info text
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Please verify your email ',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: email,
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ', this will increase the speed of your account’s approval.',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
