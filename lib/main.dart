import 'package:elibra_mobile/assets.dart';
import 'package:elibra_mobile/authentication/otp.dart';
import 'package:elibra_mobile/authentication/patron_signup.dart';
import 'package:elibra_mobile/authentication/patron_signup.dart';
import 'package:elibra_mobile/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import 'authentication/patron_login.dart';
import 'e_resources/e_resources.dart';
import 'e_resources/access_resources.dart';
import 'main_page/borrowed_history.dart';
import 'fines/fines.dart';
import 'sections/general_section.dart';
import 'sections/serial_section.dart';
import 'sections/thesis_section.dart';
import 'services/user_services.dart';
import 'authentication/users.dart';
import 'package:elibra_mobile/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkAuth() async {
    return await UserService.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final isAuth = snapshot.data ?? false;

        return MaterialApp(
          title: 'My App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: AppColors.textColor),
              floatingLabelStyle: TextStyle(color: AppColors.primaryGreen),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
              )
            ),
            fontFamily: 'Poppins',
          ),
          // initialRoute: isAuth? 'home' : '/login',
          home: isAuth ? const BottomNav() : const PatronLoginPage(),
          routes: {
            //Auth Routes
            '/login': (context) => const PatronLoginPage(),
            '/register_patron': (context) => const PatronSignUpPage(patronType: 2),
            '/select_account': (context) => const AccountTypeSelectionPage(),

            //Fetching Data
            '/profile': (context) => const ProfilePage(),
            '/eresources': (context) => const EResources(),
            '/access': (context) => const AccessResources(),
            '/borrowed_history': (context) => const BorrowedHistory(),

            //Transactions
            '/fines': (context) => const FinesPage(),

            //OPAC
            '/general': (context) => const GeneralSectionPage(),
            '/serial': (context) => const SerialSectionPage(),
            '/thesis': (context) => const ThesisSectionPage(),

            //mainPage
            '/home': (context) => const BottomNav(),


          },
        );
      },
    );
  }
}
