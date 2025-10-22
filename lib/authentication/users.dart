import 'package:elibra_mobile/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elibra_mobile/authentication/patron_signup.dart';

class AccountTypeSelectionPage extends StatelessWidget {
  const AccountTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button (top-left)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Main content (centered vertically and horizontally)
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // vertical center
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo and title
                    Column(
                      children: [
                        SvgPicture.asset(
                          AppImages.logo,
                          height: 90,
                        ),
                        const SizedBox(height: 10),
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
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Choose Account Type
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Choose ',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: 'Account Type',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Account type buttons (centered horizontally)
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        runSpacing: 20,
                        children: [
                          _AccountTypeCard(
                            icon: Icons.school,
                            label: 'Student',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatronSignUpPage(patronType: 2), //STUDENT
                                ),
                              );
                            },
                          ),
                          _AccountTypeCard(
                            icon: Icons.menu_book,
                            label: 'Faculty',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PatronSignUpPage(patronType: 1), //FACULTY
                                )
                              );
                            },
                          ),
                          _AccountTypeCard(
                            icon: Icons.group,
                            label: 'Guest',
                            onTap: () {
                              // Navigator.pushNamed(context, '/register_guest');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PatronSignUpPage(patronType: 3), //FOR GUEST ONLY
                                )
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bottom Note
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    const Text(
                      '* This page lets you choose what type of account you want to register.\n'
                      '* Please select the role that best fits you to continue with the registration process.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.redAccent,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1),
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

// Custom card widget for account options
class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 100,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
