import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'assets.dart'; 

class NoInternetModal extends StatelessWidget {
  final String message;

  const NoInternetModal({super.key, this.message = "No internet connection"});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make dialog shrink to content
          children: [
            Image.asset(
              'assets/images/wifi.png',
              width: 100,
              height: 100,
              // placeholderBuilder: (context) => const CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
