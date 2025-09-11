import 'package:flutter/material.dart';
import '../assets.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();


  String _gender = 'Male';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0, // Prevents color change on scroll (Flutter 3.7+)
        surfaceTintColor: AppColors.primaryGreen,
        title: const Text('Update Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildAvatarPicker(),
              const SizedBox(height: 24),
              Text(
                'Update Information',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              _buildFormCard(),
              const SizedBox(height: 16),
              _buildActionButtons(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: Color(0xFFE9E9EF),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 36,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGreen),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labeledField('First Name', _firstNameController),
          const SizedBox(height: 12),
          _labeledField('Last Name', _lastNameController),
          const SizedBox(height: 12),
          _labeledField('Middle Name', _middleNameController),
          const SizedBox(height: 12),
          _labeledField('Email', _emailController, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _labeledField('Contact Number', _contactController, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          Text(
            'Gender',
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              color: AppColors.textColor.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _genderButton('Male'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _genderButton('Female'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genderButton(String label) {
    final bool isSelected = _gender == label;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _gender = label;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: isSelected ? AppColors.primaryGreen :  AppColors.backgroundColor,
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : AppColors.textColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: AppTextStyles.button.copyWith(
          color: isSelected ? Colors.white : AppColors.textColor,
        ),
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 12,
            color: AppColors.textColor.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: AppColors.backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBCBD4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Reset to initial demo values
              setState(() {
                _firstNameController.text = 'John';
                _lastNameController.text = 'Doe';
                _middleNameController.text = 'Not Required';
                _emailController.text = 'sample@isu.edu.ph';
                _contactController.text = '09012345678';
                _gender = 'Male';
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFCBCBD4)),
              backgroundColor: const Color(0xFFE9E9EF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Discard',
              style: AppTextStyles.button.copyWith(color: AppColors.textColor),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Submit action placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Save Profile',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}