import 'package:elibra_mobile/authentication/student_login.dart';
import 'package:elibra_mobile/authentication/otp.dart';
import 'package:elibra_mobile/services/api.dart';
import 'package:flutter/material.dart';
import 'package:elibra_mobile/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';

class StudentSignUpPage extends StatefulWidget {
  const StudentSignUpPage({super.key});

  @override
  State<StudentSignUpPage> createState() => _StudentSignUpPageState();
}

class _StudentSignUpPageState extends State<StudentSignUpPage> {
  // Terms and conditions dialog box
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const SingleChildScrollView(
          child: Text(
            "Here you can write your Terms and Conditions...\n\n"
            "1. Rule one\n"
            "2. Rule two\n"
            "3. Etc.",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  late TapGestureRecognizer _termsTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = () => _showTermsDialog(context);
    _loadCampuses();
  }

  Future<void> _loadCampuses() async {
    setState(() {
      _isLoading = true;
    });
    
    // Add default campus option
    _campuses = [
      {'id': 1, 'name': 'ECHAGUE CAMPUS'}
    ];
    _selectedCampus = _campuses.first['id'].toString();
    
    final result = await ApiService.getCampuses();
    
    if (result['error'] == false) {
      setState(() {
        _campuses.addAll(List<Map<String, dynamic>>.from(result['data'] ?? []));
        _selectedCampus ??= _campuses.first['id'].toString();
        // _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  Future<void> _registerUser() async {
    // Debug validation
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Sex: $_selectedSex');
    print('Role: $_selectedRole');
    print('Campus: $_selectedCampus');
    print('Password: ${_passwordController.text}');
    print('Confirm Password: ${_confirmPasswordController.text}');
    
    // Validation
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedSex == null ||
        _selectedRole == null ||
        _selectedCampus == null) {
      
      String missingFields = '';
      if (_nameController.text.isEmpty) missingFields += 'Name, ';
      if (_emailController.text.isEmpty) missingFields += 'Email, ';
      if (_selectedSex == null) missingFields += 'Sex, ';
      if (_selectedRole == null) missingFields += 'Role, ';
      if (_selectedCampus == null) missingFields += 'Campus, ';
      if (_passwordController.text.isEmpty) missingFields += 'Password, ';
      if (_confirmPasswordController.text.isEmpty) missingFields += 'Confirm Password, ';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in: ${missingFields.replaceAll(', ', ', ').replaceAll(RegExp(r', $'), '')}')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Convert string values to integers as expected by Laravel
    int sexValue = _selectedSex == 'Male' ? 0 : 1;
    int roleValue = _selectedRole == 'Admin' ? 1 : 2;

    final result = await ApiService.registerUser(
      name: _nameController.text,
      sex: sexValue,
      campusId: int.parse(_selectedCampus!),
      role: roleValue,
      email: _emailController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['error'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      
      // Extract JWT token from backend response
      final data = result['data'] ?? {};
      final String? token = (data['token'] ?? data['access_token']) as String?;

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing auth token from server.')),
        );
        return;
      }

      // Navigate to OTP screen with required token
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: _emailController.text,
            token: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordVisible = false;
  String? _selectedSex;
  String? _selectedRole;
  String? _selectedCampus;
  List<Map<String, dynamic>> _campuses = [];
  bool _isLoading = false;
  
  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth > 600 ? 500 : double.infinity;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo + App Title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppImages.logo, height: 60, width: 60),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'E-Libra',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enhanced Integrated Library & Resource \nAutomation System',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'Create your \nAccount!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Form Container (like login page)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryGreen, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Name
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: AppColors.textColor,
                                ),
                                hintText: 'ex. Juan Dela a Dela Cruz',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Email
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: AppColors.textColor,
                                ),
                                hintText: 'ex. delacruzjuan@gmail.com',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Sex and Role Dropdowns
                            Row(
                              children: [
                                // Sex Dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedSex,
                                    decoration: const InputDecoration(
                                      labelText: 'Sex',
                                      labelStyle: TextStyle(
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    items: ['Male', 'Female'].map((String sex) {
                                      return DropdownMenuItem<String>(
                                        value: sex,
                                        child: Text(sex),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedSex = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Role Dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedRole,
                                    decoration: const InputDecoration(
                                      labelText: 'Role',
                                      labelStyle: TextStyle(
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    items: ['Admin', 'Student'].map((String role) {
                                      return DropdownMenuItem<String>(
                                        value: role,
                                        child: Text(role),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedRole = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Campus Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedCampus,
                              decoration: const InputDecoration(
                                labelText: 'Echague Campus',
                                labelStyle: TextStyle(
                                  color: AppColors.textColor,
                                ),
                              ),
                              items: _campuses.map((campus) {
                                return DropdownMenuItem<String>(
                                  value: campus['id'].toString(),
                                  child: Text(campus['name'] ?? ''),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCampus = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            // Password
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: AppColors.textColor,
                                  ),
                                  onPressed: () {
                                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Confirm Password
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: AppColors.textColor,
                                  ),
                                  onPressed: () {
                                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Register Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.backgroundColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Already have account
                            Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const StudentLoginPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Login',
                                          style: TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Terms & Conditions
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 12,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'By creating an account, you agree to our ',
                                        ),
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: const TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          recognizer: _termsTap,
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
