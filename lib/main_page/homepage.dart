//HOMEPAGE
import 'package:elibra_mobile/assets.dart';
import 'package:elibra_mobile/authentication/otp.dart';
import 'package:elibra_mobile/e_resources/e_resources.dart';
import 'package:elibra_mobile/fines/fines.dart';
import 'package:elibra_mobile/loading.dart';
import 'package:elibra_mobile/main_page/borrowed_history.dart';
import 'package:elibra_mobile/profile/ebc.dart';
import 'package:elibra_mobile/profile/update_profile.dart';
import 'package:elibra_mobile/sections/general_section.dart';
import 'package:elibra_mobile/sections/serial_section.dart';
import 'package:elibra_mobile/sections/thesis_section.dart';
import 'package:elibra_mobile/services/config_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import 'package:elibra_mobile/authentication/patron_login.dart';
import 'package:elibra_mobile/models/user_model.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:intl/intl.dart';
import 'dart:async';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? _user;
  bool _isLoading = true;

  String _today = "";
  String _currentTime = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setDate();
    _Time();
  }

  void _setDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMM dd, yyyy - EEEE').format(now);
    setState(() {
      _today = formattedDate;
    });

  }

  void _Time(){
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('hh:mm a').format(now);
      });
    });
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      // Load from local first
      final localUser = await UserService.getUser();
      if (localUser != null) {
        setState(() {
          _user = localUser;
          _isLoading = false;
        });
      }

      // Then refresh from API
      final result = await UserService.fetchUserProfile();

      if (result != null && result.isNotEmpty) {
        final user = User.fromJson(result);
        await UserService.saveUser(user);
        setState(() {
          _user = user;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading user data: $e');
    }
  }

Future<bool> isUserVerified() async {
  final result = await UserService.fetchUserProfile();

  if (result.isEmpty || result['error'] == true) {
    return false; 
  }

  final userData = result['user'] ?? result;

  return userData['email_verified_at'] != null;
}


Future<void> _showVerificationDialog(
  String email,
  String token,
  BuildContext outerContext, // rename this to clarify it's from outside
) async {
  final confirm = await showDialog<bool>(
    context: outerContext,
    barrierDismissible: false,
    builder: (dialogContext) => Dialog( // use dialogContext for this builder
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              "Verify Your Account",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.primaryGreen),
            const SizedBox(height: 20),

            // Info Text (centered)
            const Text(
              "Verifying your account gives you access to all the main features of E-Libra.\n\n"
              "You can verify your account now or skip and verify later.",
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(height: 2, color: AppColors.primaryGreen),
            const SizedBox(height: 16),

            // Buttons Row
            Row(
              children: [
                // Cancel
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide.none,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () => Navigator.pop(dialogContext, false),
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

                // Verify Now
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
                    onPressed: () async {
                      // ✅ close dialog using its own context
                      Navigator.pop(dialogContext, true);

                      // ✅ use outerContext for navigation/loading/dialogs
                      showDialog(
                        context: outerContext,
                        barrierDismissible: false,
                        builder: (_) => const CustomLoadingModal(
                          message: "Sending OTP...",
                        ),
                      );

                      try {
                        final res = await ApiService.sendOTP(email, token);
                        Navigator.pop(outerContext); // close loading safely

                        if (res['error'] == false) {
                          Navigator.push(
                            outerContext,
                            MaterialPageRoute(
                              builder: (_) => OTPVerificationScreen(
                                email: email,
                                userToken: token,
                                otpToken: res['data']['token'],
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(outerContext).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to send OTP. Try again.')),
                          );
                        }
                      } catch (e) {
                        Navigator.pop(outerContext); // close loading safely
                        ScaffoldMessenger.of(outerContext).showSnackBar(
                          const SnackBar(
                              content: Text('An unexpected error occurred.')),
                        );
                      }
                    },
                    child: const Text(
                      "Verify Now!",
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

  if (confirm == false) {
    print("User skipped verification.");
  }
}


void _navigateWithVerification(BuildContext context, {Widget? page}) async {
  if (_user == null) return;

  final verified = await isUserVerified();

  if (!verified) {
    
    final token = await UserService.getToken();
     if (token == null) return;

    await _showVerificationDialog(_user!.email, token, context);
    return;
  } 

  if (page != null) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
} 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
  
      // ✅ Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
               padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.1),
                    AppColors.primaryGreen.withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryGreen,
                      child: SvgPicture.asset(
                        AppImages.logo,
                        height: 32, width: 32,
                        color: AppColors.backgroundColor,
                      )
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "E-Libra",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Enhanced Integrated Library & Resource\nAutomation System",
                          style: TextStyle(
                            fontSize: 12,
                            // color: Color.fromRGBO(0, 0, 0, 0.541),
                            color: AppColors.textColor,
                            height: 1.3,
                          ),
                        ),
                      ],  
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primaryGreen),
              title: const Text("Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.credit_card, color: AppColors.primaryGreen),
              title: const Text("My e-Borrower Card"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const  BorrowerCardPage()));
              },
            ),

            const Divider(),
  
            ListTile(
              leading: const Icon(Icons.menu_book, color: AppColors.primaryGreen),
              title: const Text("OPAC"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                Navigator.pushNamed(context, '/opac');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primaryGreen),
              title: const Text("E-Resources"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                  _navigateWithVerification(context, page:  const EResources());
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: AppColors.primaryGreen),
              title: const Text("E-Libra Web"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening E-Libra Web...')),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.help, color: AppColors.primaryGreen),
              title: const Text("E-Libra Manual"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening E-Libra Manual...')),
                );
              },
            ),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Log Out"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Are you sure you want to log out?",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop(); // close bottom sheet first

                                await UserService.logout();

                                if (context.mounted) {

                                 Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Logout Successfully!'),
                                      backgroundColor: Colors.green,
                                    ),  
                                  );
                                }
                              },

                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  color: AppColors.backgroundColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // ✅ AppBar
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        title: Row(
          children: [
            SvgPicture.asset(AppImages.logo, height: 32, width: 32),
            const SizedBox(width: 8),
            const Text(
              "E-Libra",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),

      // ✅ Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _today,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            // Student Info Card
            Card(
              color: AppColors.primaryGreen.withOpacity(0.05),
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: Padding(
                // padding: const EdgeInsets.all(14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _user?.profilePicture != null
                            ? Image.network(
                                _user!.profilePicture!.url,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _profilePlaceholder();
                                },
                              )
                            : _profilePlaceholder(),
                      ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Greeting + Name
                          Text(
                            _isLoading
                                ? "Loading..."
                                : _user != null
                                    ? "${_user!.greeting}👋, ${_user!.first_name} ${_user!.last_name}!"
                                    : "Hello 👋, Guest!",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // ID number (Fetched from API)
                        _isLoading
                            ? const Text(
                                "Loading...",
                                style: TextStyle(fontSize: 12, color: AppColors.textColor,  fontWeight: FontWeight.bold),
                              )
                            : (_user?.id_number != null && _user!.id_number!.isNotEmpty)
                                ? RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 12, color: AppColors.textColor,  fontWeight: FontWeight.w500),
                                        children: [
                                          const TextSpan(
                                            text: "ID Number: ",
                                            style: TextStyle(fontWeight: FontWeight.bold), // medium weight
                                          ),
                                          TextSpan(text: _user!.id_number),
                                        ],
                                      ),
                                    )
                                  : const Text(
                                      "No ID Number!",
                                      style: TextStyle(fontSize: 12, color: AppColors.textColor),
                                    ),
                          const SizedBox(height: 6),
                // Campus (Fetched)
                _isLoading
                    ? const Text(
                        "Loading...",
                        style: TextStyle(fontSize: 12, color: AppColors.textColor),
                      )
                    : (_user == null)
                        ? const Text(
                            "Please log in",
                            style: TextStyle(fontSize: 12, color: AppColors.textColor),
                          )
                        : RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textColor,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Campus: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan( 
                                  text: _user!.patron_type == 3
                                      ? (_user!.external_organization?.isNotEmpty == true
                                          ? _user!.external_organization
                                          : "Not Specified!")
                                      : (_user!.campus != null
                                          ? _user!.campus!.name
                                          : "Not Specified"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ⭐ Features
            Text("Features",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.5,
                )),
            const SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 4, right: 16),
                children: [
                  _featureCard(Icons.menu_book, "E-Resources", onTap: () {
                    // Navigator.pushNamed(context, '/eresources');
                    _navigateWithVerification(context, page: EResources());
                  }),
                  _featureCard(Icons.money, "Fines", onTap: () {
                    // Navigator.pushNamed(context, '/fines');
                    _navigateWithVerification(context, page: FinesPage());
                  }),
                  _featureCard(Icons.history, "Borrowed History", onTap: () {
                    // Navigator.pushNamed(context, '/borrowed_history');
                    _navigateWithVerification(context, page: BorrowedHistory());
                  }),
                  _featureCard(Icons.offline_pin, "Offline Access", onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Offline Access feature coming soon!')),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📚 Sections
            Text("Sections",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.5,
                )),
            const SizedBox(height: 12),

            _sectionCard("Thesis Section", () => _navigateWithVerification(context, page: const ThesisSectionPage())),
            _sectionCard("General Section", () => _navigateWithVerification(context, page: const GeneralSectionPage())),
            _sectionCard("Serial Section", () => _navigateWithVerification(context, page: const SerialSectionPage())),

          ],
        ),
      ),
    );
  }

  // 🔧 Feature Card
  static Widget _featureCard(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGreen.withOpacity(0.08),
              AppColors.primaryGreen.withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.only(right: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 Section Card
  static Widget _sectionCard(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.08),
            AppColors.primaryGreen.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getSectionIcon(title),
            size: 20,
            color: AppColors.primaryGreen,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: AppColors.textColor,
            letterSpacing: 0.3,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.primaryGreen,
          ),
        ),
        onTap: onTap
      ),
    );
  }

  // Helper method to get section icons
  static IconData _getSectionIcon(String title) {
    switch (title) {
      case 'Thesis Section':
        return Icons.description;
      case 'General Section':
        return Icons.library_books;
      case 'Serial Section':
        return Icons.article;
      default:
        return Icons.folder;
    }
  }

static Widget _getPageFromRoute(String route) {
  switch (route) {
    case '/thesis':
      return const ThesisSectionPage(); 
    case '/general':
      return const GeneralSectionPage();
    case '/serial':
      return const SerialSectionPage();
    default:
      return const Homepage();
  }
}


Widget _profilePlaceholder() {
  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
      color: AppColors.primaryGreen.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
      Icons.person,
      size: 35,
      color: AppColors.primaryGreen,
    ),
  );
}

}
