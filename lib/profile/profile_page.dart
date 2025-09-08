import 'package:flutter/material.dart';
import '../assets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Rounded square
                  child: Image.asset(
                    "assets/images/Anya.jpg", // replace with your image path
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Eugene G. Tobias!",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "College of Computing Studies Information and Communication Technology",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "22-1081",
                          style: TextStyle(
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
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 2,
              color: AppColors.textColor.withOpacity( 0.1),
            ),

            SizedBox(height: 16),
            Card(
              color: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.book_rounded, color: AppColors.primaryGreen),
                title: const Text("Course",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.primaryGreen)
                  ),
                subtitle: const Text("Bachelor's of Science in Information Technology",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textColor)
                  ),
              ),
            ),
            SizedBox(height: 12),
            Card(
              color: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person_2_rounded, color: AppColors.primaryGreen),
                title: const Text("Username",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.primaryGreen)
                  ),
                subtitle: const Text("Super Frince",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textColor)
                  ),
              ),
            ),
            SizedBox(height: 12),
            Card(
              color: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.call, color: AppColors.primaryGreen),
                title: const Text("Contact Number",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.primaryGreen)
                  ),
                subtitle: const Text("0912345678",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textColor)
                  ),
              ),
            ),
            // Borrower's Card Section
            const SizedBox(height: 16),
            const Text(
              "Borrower's Card",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300], // background (like the gray in your design)
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + ID Row
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: const Text("Logo",
                            style: TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "ISUE-2210812024",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Certification text (aligned right)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Certified Student",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
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
  }
}
