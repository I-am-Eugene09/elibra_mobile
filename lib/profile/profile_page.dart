import 'package:elibra_mobile/loading.dart';
import 'package:elibra_mobile/services/api.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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


  String translateDate(String? dateString){
    if(dateString == null || dateString.isEmpty) return 'Not Verified!';
    try{
      final date = DateTime.parse(dateString);

      final formattedDate = DateFormat('MMMM dd, yyyy').format(date);

      return formattedDate;
    }catch(e){
      return 'inavlid date format';
    }
  }

String patronType (dynamic type) {
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
String roleType (dynamic type){
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
                          child: user['profile_photo'] != null
                              ? Image.network(
                                  user['profile_photo']['path'],
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
                                user['campus']?['name'] ?? "No campus data",
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
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text( "ID Number: " +
                                  user['id_number'] ?? "No ID Number",
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

                  const Text(
                    "Personal Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textColor, 
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 📌 Info
                  // _infoTile(Icons.gender, "Sex", (user['sex'] == "male") ? "Male" : "Female"),
                  _infoTile(
                    (user['sex'] == "male") ? Icons.male : Icons.female,
                    "Sex",
                    (user['sex'] == "male") ? "Male" : "Female",
                  ),
                  _infoTile(Icons.call, "Contact Number", user['contact_number'] ?? "Not Specified"),
                  _infoTile(Icons.email, "Email", user['email'] ?? "N/A"),
                  // _infoTile(Icons.location_city, "Address", user['address'] ?? "Not Specified!"),


                const SizedBox(height: 24),

                Text(
                  "Account Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),

                const SizedBox(height: 12),

                  _infoTile(
                    Icons.account_box,
                    "Account Type",
                    (user["role"] != null && user["patron_type"] != null)
                        ? "${roleType(user["role"])} - ${patronType(user["patron_type"])}"
                        : "Not Specified!",
                  ),

                  _infoTile(Icons.calendar_month, "Date Verified", translateDate(user["email_verified_at"])),
                  _infoTile(Icons.calendar_view_day, "Date Created", translateDate(user["date_joined"])),


                  const SizedBox(height: 24),

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
