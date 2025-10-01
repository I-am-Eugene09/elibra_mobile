import 'package:elibra_mobile/loading.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:flutter/material.dart';
import '../assets.dart';
import 'update_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = UserService.fetchUserProfile();
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _profileFuture = UserService.fetchUserProfile();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primaryGreen),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfilePage()),
              );
              _refreshProfile();
            },
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CustomLoadingModal(message: "Loading profile..."));

          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Failed to load profile"));
          }

          final user = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 Profile Header
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: (user['profile_picture'] != null &&
                                  user['profile_picture']['url'] != null)
                              ? Image.network(
                                  user['profile_picture']['url'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _profilePlaceholder();
                                  },
                                )
                              : _profilePlaceholder(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'] ?? "Unknown",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user['campus']?['campus'] ?? "No campus data",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['id'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: AppColors.textColor.withOpacity(0.1),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 24),

                  // 📌 Info
                  _infoTile(Icons.person, "Sex", (user['sex'] == "1") ? "Male" : "Female"),
                  _infoTile(Icons.call, "Contact Number", user['contact_number'] ?? "N/A"),
                  _infoTile(Icons.email, "Email", user['email'] ?? "N/A"),

                  const SizedBox(height: 24),

                  // 📇 Borrower's Card Section
                  const Text(
                    "Borrower's Card",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              child: const Icon(Icons.library_books,
                                  color: AppColors.primaryGreen, size: 26),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                "ISUE-2210812024",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Certified Student",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
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

  static Widget _infoTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0.08),
            AppColors.primaryGreen.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.primaryGreen,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }

  Widget _profilePlaceholder() {
    return Container(
      width: 70,
      height: 70,
      color: AppColors.primaryGreen.withOpacity(0.1),
      child: const Icon(
        Icons.person,
        size: 35,
        color: AppColors.primaryGreen,
      ),
    );
  }
}
