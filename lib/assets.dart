import 'package:flutter/material.dart';

//For App Colors
class AppColors{
  static const primaryGreen = Color(0xFF04B954);
  static const backgroundColor = Color(0xFFF7F7FF);
  static const textColor = Color(0xFF22223b);
}

//For App Images
class AppImages{
  static const logo = 'assets/images/Logo.svg';
}

//For App AppTextStyles 
class AppTextStyles {
  static const heading = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  );

  static const body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: AppColors.textColor,
  );

  static const button = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  );

  static const link = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.primaryGreen,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );
}


