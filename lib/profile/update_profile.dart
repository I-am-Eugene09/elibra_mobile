import 'package:elibra_mobile/main_page/homepage.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../assets.dart';
import 'dart:io';

class UpdateProfilePage extends StatefulWidget {
  
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  String? _gender;
  File? _pickedImage;

  bool _isLoading = true;

  // keep a copy of original values for discard
  Map<String, dynamic> _originalData = {};
  Map<String, String> fieldsToUpdate = {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

Future<void> _loadProfile() async {
  setState(() => _isLoading = true);
  final result = await UserService.fetchUserProfile();

  if (mounted) {
    Map<String, dynamic> data = {};

    if (result['error'] == false) {
      // wrapped response with error flag
      data = result['user'] ?? result;
    } else if (result['id'] != null) {
      // unwrapped response (raw user object)
      data = result;
    } else {
      // fallback for backend returning { error:true }
      _isLoading = false;
      setState(() {});
      return;
    }

    String fullName = data['name'] ?? '';
    List<String> name = fullName.split(" ");

    _firstNameController.text = name.isNotEmpty ? name.first : "";
    _lastNameController.text = name.length > 1 ? name.last : "";
    _middleNameController.text = name.length > 2 ? name.sublist(1, name.length - 1).join(" ") : "";
    _emailController.text = data['email'] ?? '';
    _contactController.text = data['contact_number'] ?? '';
    _gender = data['sex'] == "1" ? "Male" : "Female";

    // keep original values
    _originalData = {
      'full_name': fullName,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'middle_name': _middleNameController.text,
      'email': _emailController.text,
      'contact_number': _contactController.text,
      'gender': _gender,
      'profile_picture': data['profile_picture'],
    };

    _isLoading = false;
    setState(() {});
  }
}

Future<void> _saveProfile() async {
  if (!_formKey.currentState!.validate()) return;

  // Merge full name
  String fullName = [
    _firstNameController.text.trim(),
    _middleNameController.text.trim(),
    _lastNameController.text.trim()
  ].where((e) => e.isNotEmpty).join(' ');

  // Prepare fields that actually changed
  Map<String, String> fieldsToUpdate = {};
  if (fullName != _originalData['full_name']) fieldsToUpdate['name'] = fullName;
  if (_emailController.text.trim() != (_originalData['email'] ?? '')) {
    fieldsToUpdate['email'] = _emailController.text.trim();
  }
  if (_contactController.text.trim() != (_originalData['contact_number'] ?? '')) {
    fieldsToUpdate['contact_number'] = _contactController.text.trim();
  }
  if ((_gender ?? '') != (_originalData['gender'] ?? '')) {
    fieldsToUpdate['sex'] = _gender == 'Male' ? '1' : '0';
  }

  if (fieldsToUpdate.isEmpty && _pickedImage == null) {
    // Nothing changed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No changes to update'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  final result = await UserService.updateProfile(
    name: fieldsToUpdate['name'],
    email: fieldsToUpdate['email'],
    contact_number: fieldsToUpdate['contact_number'],
    sex: fieldsToUpdate['sex'],
    avatar: _pickedImage,
  );

  setState(() => _isLoading = false);

  if (!mounted) return;

  if (result['error'] == false && result['status'] == 'success') {
    // Update local original data
    final updatedUser = result['user'] ?? {};
    setState(() {
      _originalData['full_name'] = updatedUser['name'] ?? fullName;
      _originalData['email'] = updatedUser['email'] ?? _emailController.text;
      _originalData['contact_number'] = updatedUser['contact_number'] ?? _contactController.text;
      _originalData['gender'] = updatedUser['sex'] == '1' ? 'Male' : 'Female';
      if (_pickedImage != null) {
        _originalData['profile_picture'] = _pickedImage;
        _pickedImage = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Profile updated successfully'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushNamed(context, '/profile');
      }
    }); 
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Update failed'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }
}

  void _discardChanges() {
    setState(() {
      _firstNameController.text = _originalData['first_name'] ?? '';
      _lastNameController.text = _originalData['last_name'] ?? '';
      _middleNameController.text = _originalData['middle_name'] ?? '';
      _emailController.text = _originalData['email'] ?? '';
      _contactController.text = _originalData['contact_number'] ?? '';
      _gender = _originalData['gender'];
      _pickedImage = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.primaryGreen,
        title: const Text('Update Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Form(
                  key: _formKey,
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
            ),
    );
  }

Widget _buildAvatarPicker() {
  return Center(
    child: GestureDetector(
      onTap: () async {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _pickedImage = File(pickedFile.path);
          });
        }
      },
      child: CircleAvatar(
        radius: 56,
        backgroundColor: const Color(0xFFE9E9EF),
        backgroundImage:
            _pickedImage != null ? FileImage(_pickedImage!) : null,
        child: _pickedImage == null
            ? const Icon(
                Icons.camera_alt_outlined,
                size: 36,
                color: AppColors.primaryGreen,
              )
            : null,
      ),
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
              Expanded(child: _genderButton('Male')),
              const SizedBox(width: 12),
              Expanded(child: _genderButton('Female')),
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
        backgroundColor: isSelected ? AppColors.primaryGreen : AppColors.backgroundColor,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
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
            onPressed: _discardChanges,
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
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Save Profile',
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
