import 'dart:io';
import 'package:elibra_mobile/loading.dart';
import 'package:elibra_mobile/main_page/homepage.dart';
import 'package:elibra_mobile/profile/profile_page.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../assets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

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
  final _addressController = TextEditingController();

  String? _gender;
  File? _pickedImage;
  bool _isLoading = true;

  Map<String, dynamic> _originalData = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    // _addressController.dispose();
    super.dispose();
  }

  // ✅ Load profile info from API
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final result = await UserService.fetchUserProfile();

    if (!mounted) return;

    if (result.isEmpty || result['error'] == true) {
      setState(() => _isLoading = false);
      return;
    }

    final data = result['user'] ?? result;

    _firstNameController.text = data['first_name'] ?? '';
    _lastNameController.text = data['last_name'] ?? '';
    _middleNameController.text = data['middle_initial'] ?? '';
    _emailController.text = data['email'] ?? '';
    _contactController.text = data['contact_number'] ?? '';
    // _addressController.text = data['address'] ?? '';
    _gender = (data['sex'] == 'male') ? 'Male' : 'Female';

    _originalData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'middle_initial': _middleNameController.text,
      'email': _emailController.text,
      'contact_number': _contactController.text,
      // 'address': _addressController.text,
      'gender': _gender,
      'profile_picture': data['profile_picture'],
    };

    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Extract middle initial automatically if more than 1 letter
    String middleInput = _middleNameController.text.trim();
    String middleInitial =
        middleInput.isNotEmpty ? middleInput[0].toUpperCase() : '';

    Map<String, String> fieldsToUpdate = {};

    if (_firstNameController.text.trim() != (_originalData['first_name'] ?? '')) {
      fieldsToUpdate['first_name'] = _firstNameController.text.trim();
    }
    if (_lastNameController.text.trim() != (_originalData['last_name'] ?? '')) {
      fieldsToUpdate['last_name'] = _lastNameController.text.trim();
    }
    if (middleInitial != (_originalData['middle_initial'] ?? '')) {
      fieldsToUpdate['middle_initial'] = middleInitial;
    }
    if (_emailController.text.trim() != (_originalData['email'] ?? '')) {
      fieldsToUpdate['email'] = _emailController.text.trim();
    }
    if (_contactController.text.trim() != (_originalData['contact_number'] ?? '')) {
      fieldsToUpdate['contact_number'] = _contactController.text.trim();
    }
    // if(_addressController.text.trim() != (_originalData['address'] ?? '')){
    //   fieldsToUpdate['address'] = _addressController.text.trim();
    // }
    if ((_gender ?? '') != (_originalData['gender'] ?? '')) {
      fieldsToUpdate['sex'] = _gender == 'Male' ? 'male' : 'female';
    }

    if (fieldsToUpdate.isEmpty && _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to update'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomLoadingModal(message: "Updating profile..."),
    );

    final result = await UserService.updateProfile(
      firstName: fieldsToUpdate['first_name'],
      lastName: fieldsToUpdate['last_name'],
      middleInitial: fieldsToUpdate['middle_initial'],
      email: fieldsToUpdate['email'],
      contactNumber: fieldsToUpdate['contact_number'],
      sex: fieldsToUpdate['sex'],
      // address: fieldsToUpdate['address'],
      avatar: _pickedImage,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (result['error'] == false && result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Profile updated successfully'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Update failed'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      print(result['message']);
    }
  }

  // ✅ Discard Changes
  void _discardChanges() {
    setState(() {
      _firstNameController.text = _originalData['first_name'] ?? '';
      _lastNameController.text = _originalData['last_name'] ?? '';
      _middleNameController.text = _originalData['middle_initial'] ?? '';
      _emailController.text = _originalData['email'] ?? '';
      _contactController.text = _originalData['contact_number'] ?? '';
      // _addressController.text = _originalData['address'] ?? '';
      _gender = _originalData['gender'];
      _pickedImage = null;
    });
    Navigator.push(context,  MaterialPageRoute(builder: (context) => Homepage()));
  }

Future<void> _pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return;

  final imageFile = File(picked.path);

  // Get image dimensions
  final decodedImage = await decodeImageFromList(await imageFile.readAsBytes());
  final imageWidth = decodedImage.width.toDouble();
  final imageHeight = decodedImage.height.toDouble();
  final imageArea = imageWidth * imageHeight;

  // Run face detection
  final inputImage = InputImage.fromFile(imageFile);
  final options = FaceDetectorOptions(
    enableContours: false,
    enableClassification: false,
  );
  final faceDetector = FaceDetector(options: options);
  final faces = await faceDetector.processImage(inputImage);
  faceDetector.close();

  if (faces.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No face detected. Please upload a clear photo of yourself.'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
    return;
  } else if (faces.length > 1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Multiple faces detected. Please upload only your photo.'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
    return;
  }

  // Face size check
  final face = faces.first;
  final faceArea = face.boundingBox.width * face.boundingBox.height;
  if (faceArea / imageArea < 0.05) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Face is too small or zoomed out. Please upload a closer photo.'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
    return;
  }

  // ✅ Valid face → set image
  setState(() {
    _pickedImage = imageFile;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.primaryGreen,
        title: const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: _isLoading
          ? const CustomLoadingModal(message: "Loading profile...")
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.05),
                          AppColors.primaryGreen.withOpacity(0.02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAvatarPicker(),
                        const SizedBox(height: 18),
                        Text(
                          'Update Information',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 16,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildFormCard(),
                        const SizedBox(height: 20),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 56,
          backgroundColor: const Color(0xFFE9E9EF),
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!)
                : null,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeledField('First Name', _firstNameController),
        const SizedBox(height: 12),
        _labeledField('Last Name', _lastNameController),
        const SizedBox(height: 12),
        _labeledField('Middle Name', _middleNameController),
        const SizedBox(height: 12),
        // _labeledField('Address', _addressController),
        // const SizedBox(height: 12),
        _labeledField('Email', _emailController,
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 12),
        _labeledField('Contact Number', _contactController,
            keyboardType: TextInputType.phone),
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
    );
  }

  Widget _genderButton(String label) {
    final bool isSelected = _gender == label;
    return OutlinedButton(
      onPressed: () => setState(() => _gender = label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor:
            isSelected ? AppColors.primaryGreen : AppColors.backgroundColor,
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : AppColors.textColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: AppTextStyles.button.copyWith(
          color: isSelected ? Colors.white : AppColors.textColor,
          fontWeight: FontWeight.w600,
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
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          validator: (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: AppColors.backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBCBD4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryGreen, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed: _discardChanges,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Discard",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
