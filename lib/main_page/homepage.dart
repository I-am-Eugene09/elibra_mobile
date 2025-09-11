import 'package:elibra_mobile/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import 'package:elibra_mobile/authentication/patron_login.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      // ✅ Drawer (Sidebar)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
                      child: const Icon(
                        Icons.library_books,
                        color: Colors.white,
                        size: 20,
                      ),
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
                            color: AppColors.textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Enhanced Integrated Library & Resource\nAutomation System",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('e-Borrower Card feature coming soon!')),
                  );
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
                  Navigator.pushNamed(context, '/eresources');
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
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); 
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PatronLoginPage()),
                                  (route) => false,
                                );
                              },
                              child: const Text("Confirm"),
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
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
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
            // 👤 Student Info Card
            Card(
              color: AppColors.primaryGreen.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/Anya.jpg",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hello 👋, Eugene G. Tobias!",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "22-1081 · BSIT 3-1\nIsabela State University - Main Campus",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
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
                    Navigator.pushNamed(context, '/eresources');
                  }),
                  _featureCard(Icons.money, "Fines", onTap: () {
                    Navigator.pushNamed(context, '/fines');
                  }),
                  _featureCard(Icons.history, "Borrowed History", onTap: () {
                    Navigator.pushNamed(context, '/borrowed_history');
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

            _sectionCard(context, "Thesis Section", "/thesis"),
            _sectionCard(context, "General Section", "/general"),
            _sectionCard(context, "Serial Section", "/serial"),
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
  static Widget _sectionCard(BuildContext context, String title, String route) {
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
        onTap: () {
          Navigator.pushNamed(context, route);
        },
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
}
