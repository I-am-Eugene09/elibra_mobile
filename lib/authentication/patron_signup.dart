import 'package:elibra_mobile/authentication/patron_login.dart';
import 'package:elibra_mobile/authentication/otp.dart';
import 'package:elibra_mobile/services/fetch_data.dart';
import 'package:elibra_mobile/services/config_auth.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:elibra_mobile/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';

class PatronSignUpPage extends StatefulWidget {
  const PatronSignUpPage({super.key});

  @override
  State<PatronSignUpPage> createState() => _PatronSignUpPageState();
}

class _PatronSignUpPageState extends State<PatronSignUpPage> {
  int _step = 0;
  bool _isPasswordVisible = false;
  String? _selectedSex;
  String? _selectedCampus;
  List<Map<String, dynamic>> _campuses = [];
  bool _isCampusesLoading = false;
  bool _isRegisterLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late TapGestureRecognizer _termsTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = () => _showTermsDialog(context);
    _loadCampuses();
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadCampuses() async {
    setState(() => _isCampusesLoading = true);

    final result = await FetchDataService.getCampuses();

    if (result['error'] == false) {
      setState(() {
        _campuses = List<Map<String, dynamic>>.from(result['data'] ?? []);
        if (_campuses.isNotEmpty) {
          _selectedCampus = _campuses.first['id'].toString();
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }

    setState(() => _isCampusesLoading = false);
  }

  Future<void> _registerUser() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedSex == null ||
        _selectedCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isRegisterLoading = true);

    try {
      String sexValue = _selectedSex == 'Male' ? '1' : '0';
      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
              .trim();

      final result = await ApiService.registerUser(
        name: fullName,
        sex: sexValue,
        campusId: int.parse(_selectedCampus!),
        email: _emailController.text.trim(),
        role: '2',
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (result['error'] == false) {
        final data = result['data'] ?? {};
        final String? token =
            (data['token'] ?? data['access_token']) as String?;

        if (token == null || token.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Missing auth token from server.')),
          );
        } else {
          await UserService.saveToken(token);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                email: _emailController.text.trim(),
                token: token,
              ),
            ),
          );
        }
      } else {
        String message = result['message'] ?? 'Registration failed';
        if (result['errors'] != null && result['errors'] is Map) {
          final errors = result['errors'] as Map;
          if (errors.isNotEmpty) {
            message = errors.values
                .map((e) => e is List ? e.join(", ") : e.toString())
                .join("\n");
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isRegisterLoading = false);
    }
  }

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
            "Here you can write your Terms and Conditions...\n\n1. Rule one\n2. Rule two\n3. Etc.",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _buildStepOne() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          const SizedBox(height: 16),

          // Sex selection
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sex',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Male', 'Female'].map((sex) {
                  final isSelected = _selectedSex == sex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSex = sex),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : Colors.transparent,
                          border: Border.all(color: AppColors.primaryGreen),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          sex,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Campus dropdown
          _isCampusesLoading
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCampus,
                    decoration: const InputDecoration(labelText: 'Campus'),
                    items: _campuses
                        .map<DropdownMenuItem<String>>((campus) {
                      return DropdownMenuItem<String>(
                        value: campus['id'].toString(),
                        child: Text(campus['campus'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCampus = val),
                  ),
                ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              if (_firstNameController.text.isEmpty ||
                  _lastNameController.text.isEmpty ||
                  _selectedSex == null ||
                  _selectedCampus == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }
              setState(() => _step = 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.textColor,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.textColor,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isRegisterLoading ? null : _registerUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isRegisterLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _step == 1
          ? AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.primaryGreen),
                onPressed: () => setState(() => _step = 0),
              ),
            )
          : null,
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppImages.logo, height: 60, width: 60),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('E-Libra',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen)),
                        SizedBox(height: 4),
                        Text(
                          'Enhanced Integrated Library & Resource \nAutomation System',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Create an Account',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen)),
                const SizedBox(height: 14),
                IndexedStack(
                    index: _step,
                    children: [_buildStepOne(), _buildStepTwo()]),
                const SizedBox(height: 20),
                if (_step == 0)
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Already have an account? ',
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PatronLoginPage()));
                          },
                          child: const Text('Login',
                              style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
