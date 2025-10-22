import 'package:flutter/material.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../assets.dart';
import '../loading.dart';

class BorrowerCardPage extends StatefulWidget {
  const BorrowerCardPage({super.key});

  @override
  State<BorrowerCardPage> createState() => _BorrowerCardPageState();
}

class _BorrowerCardPageState extends State<BorrowerCardPage> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile();
  }

  Future<Map<String, dynamic>> _fetchProfile() async {
    final profile = await UserService.fetchUserProfile();
    return profile; // returns the whole profile map
  }

  // Convert patron type to readable string
  String patronType(dynamic type) {
    switch (type) {
      case 1:
        return "Student";
      case 2:
        return "Faculty";
      case 3:
        return "Guest";
      default:
        return "Unknown";
    }
  }

  // Convert role type to readable string
  String roleType(dynamic type) {
    switch (type) {
      case "1":
        return "Librarian";
      case "2":
        return "Patron";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Borrower's Card"),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomLoadingModal(message: "Loading E-Borrower Card..."),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Failed to load Borrower's Card"));
          }

          final profile = snapshot.data!;
          final ebc = profile['ebc'] ?? "N/A";
          final patron = patronType(profile['patron_type']);
          final role = roleType(profile['role']);

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.08),
                    AppColors.primaryGreen.withOpacity(0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top-left icons
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                            AppImages.logo,
                            width: 26, height: 26,
                            // color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.school,
                          color: AppColors.primaryGreen,
                          size: 26,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Centered EBC text
                  Center(
                    child: Column(
                      children: [
                        Text(
                          ebc,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$patron - $role",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Bottom-right "Certified Student"
                  Align(
                    alignment: Alignment.bottomRight,
                    child: const Text(
                      "Certified.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
