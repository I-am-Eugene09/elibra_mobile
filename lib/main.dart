// import 'package:elibra_mobile/main_page/homepage.dart';
import 'package:flutter/material.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import '../authentication/patron_login.dart';
import '../e_resources/e_resources.dart';
import '../e_resources/access_resources.dart';
import '../main_page/borrowed_history.dart';
import '../fines/fines.dart';
import '../sections/general_section.dart';
import '../sections/serial_section.dart';
import '../sections/thesis_section.dart';
import 'bottom_nav.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      // home: const PatronLoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const PatronLoginPage(),
        '/profile': (context) => const ProfilePage(),
        '/eresources': (context) => const EResources(),
        '/access': (context) => const AccessResources(),
        '/borrowed_history': (context) => const BorrowedHistory(),
        '/fines': (context) => const FinesPage(),
        '/general': (context) => const GeneralSectionPage(),
        '/serial': (context) => const SerialSectionPage(),
        '/thesis': (context) => const ThesisSectionPage(),
        '/home': (context) => const BottomNav(),
      },
    );
  }
}
