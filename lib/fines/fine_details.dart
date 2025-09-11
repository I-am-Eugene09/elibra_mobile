import 'package:flutter/material.dart';
import '../assets.dart';

class FineDetailsPage extends StatelessWidget {
  const FineDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar( 
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fine Details',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primaryGreen.withOpacity(0.25), width: 4),
                right: BorderSide(color: AppColors.primaryGreen.withOpacity(0.25), width: 4),
              ),
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.08),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Borrowed Time Expired!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Icon placeholder (preserved)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryGreen.withOpacity(0.6),
                            width: 2,
                          ),
                          color: AppColors.primaryGreen.withOpacity(0.06),
                        ),
                        child: const Center(
                          child: Icon(Icons.warning_amber_rounded, color: AppColors.primaryGreen),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Book Information (preserved structure)
                      _buildInfoRow('Title:', 'JAVA Edition 2.0'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Author:', 'John Doe'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Location:', 'General Section'),

                      const SizedBox(height: 16),
                      Divider(color: AppColors.primaryGreen.withOpacity(0.1)),
                      const SizedBox(height: 16),

                      _buildInfoRow('Date & Time:', 'Feb 21, 2021 - 10:00 AM'),

                      const SizedBox(height: 16),
                      Divider(color: AppColors.primaryGreen.withOpacity(0.1)),
                      const SizedBox(height: 16),

                      // Important Notice (preserved copy with styling)
                      const Text(
                        'Important Notice!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Our records indicate that the book you borrowed is now overdue. Please return it immediately to avoid further penalties.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Continued failure to return the book may result in suspension of borrowing privileges, late fees, or a hold on your library account.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'If you have already returned the book, please contact the library staff to update your records.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Thank you for your prompt attention to this matter.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

