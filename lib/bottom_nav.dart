import 'package:flutter/material.dart';
import '../main_page/homepage.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import '../assets.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Homepage(),
    ProfilePage(),
    // ActivityPage(),
    // RecordsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex < _pages.length
          ? _pages[_currentIndex]
          : _pages[0], // fallback if index is out of range

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Activity"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Records"),
        ],
      ),
    );
  }
}
