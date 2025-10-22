import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elibra_mobile/assets.dart';

class ValidationDialogs {

  static void showValidationDialog(
    BuildContext context,
      String message, {
      String title = "Info",
      String? svgAsset,
      double msgFontSize = 16,
      FontWeight msgFontWeight = FontWeight.w500,
  }){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (svgAsset != null) ...[
                SvgPicture.asset(
                  svgAsset,
                  width: 200,
                  height: 180,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: msgFontSize, fontWeight: msgFontWeight),
              ),
            ],
          ),
        ),
      )
    );
  }

  static void emptyField(BuildContext context){
    showValidationDialog(
      context, 
      "Please fill in all fields", 
      title: "Empty Field",
      svgAsset: "assets/images/no_input.svg",
      );
  }

  static void invalidCredentials(BuildContext context){
    showValidationDialog(
      context, 
      "Check your Password and Email!",
      title: "Invalid Credentials",
      svgAsset: "assets/images/invalid_credentials.svg",
      );
  }

  static void EmailExist(BuildContext context){
    showValidationDialog(
      context,
      "Email Already Taken!",
      title: "Email Exist",
      svgAsset: "assets/images/invalid_credentials.svg",
    );
  }

  static void passwordNotMatch(BuildContext context){
    // showValidationDialog(context, "The passwords you entered do not match. Please try again.", title: "Password Mismatch");
    showValidationDialog(
      context, 
      "The passwords you entered do not match. Please try again.", 
      title: "Password Mismatch",
      svgAsset: "assets/images/invalid_credentials.svg",
      );
  }

  static void incorrectEmail(BuildContext context){
    showValidationDialog(context, "The email address you entered is not registered. Please check and try again.", title: "Email Not Found");
  }


  static void pendingApproval(BuildContext context){
    showValidationDialog(
      context, 
      "Account is pending for registration approval.",
      title: "Pending Approval",
      svgAsset: "assets/images/Pending.svg",
      );
  }

  static void genericError(BuildContext context) {
  showValidationDialog(
    context, 
    "An unexpected error occurred. Please try again later.",
    title: "Error",
    // svgAsset: "assets/images/no_input.svg",
  );
}


}