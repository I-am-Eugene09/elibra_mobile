import 'package:elibra_mobile/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import 'package:elibra_mobile/authentication/student_login.dart';

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
              decoration: const BoxDecoration(color: AppColors.backgroundColor),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    child: const Text("Logo"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "E-Libra",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Enhanced Integrated Library & Resource\nAutomation System",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),

            const ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("My e-Borrower Card"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),

            const Divider(),

            const ListTile(
              leading: Icon(Icons.menu_book),
              title: Text("OPAC"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const ListTile(
              leading: Icon(Icons.book),
              title: Text("E-Resources"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text("E-Libra Web"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),

            const Divider(),

            const ListTile(
              leading: Icon(Icons.help),
              title: Text("E-Libra Manual"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the bottom sheet

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const StudentLoginPage()),
                                  (route) => false, // remove all previous routes
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
                                Navigator.of(context).pop(); // Just close sheet
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

      // ✅ AppBar with Burger
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor), // burger color
        title: Row(
          children: [
            SvgPicture.asset(AppImages.logo, height: 32, width: 32),
            const SizedBox(width: 8),
            const Text(
              "E-Libra",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),

      // ✅ Body content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 👤 Student Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12), // rounded square
                      child: Image.asset(
                        "assets/images/Anya.jpg",
                        width: 90,
                        height: 90,
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
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "22-1081\nBSIT 3-1\nIsabela State University - Main Campus",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ⭐ Features
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Features",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("View All",
                    style: TextStyle(color: AppColors.primaryGreen)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                    Navigator.pushNamed(context, '/offline');
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 📚 Sections
            const Text("Sections",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _sectionCard("Thesis Section"),
            _sectionCard("General Section"),
            _sectionCard("Serial Section"),
          ],
        ),
      ),
    );
  }

  // 🔧 Reusable Feature Card
  static Widget _featureCard(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: AppColors.primaryGreen),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔧 Reusable Section Card
  static Widget _sectionCard(String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // navigate to section page
        },
      ),
    );
  }
}
