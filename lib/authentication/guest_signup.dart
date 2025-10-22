import 'package:elibra_mobile/authentication/account_verification.dart';
import 'package:elibra_mobile/authentication/patron_login.dart';
// import 'package:elibra_mobile/authentication/otp.dart';
import 'package:elibra_mobile/services/fetch_data.dart';
import 'package:elibra_mobile/services/config_auth.dart';
import 'package:elibra_mobile/services/user_services.dart';
import 'package:elibra_mobile/validations.dart';
import 'package:flutter/material.dart';
import 'package:elibra_mobile/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class PatronSignUpPage extends StatefulWidget {
  final int patronType;
  const PatronSignUpPage({super.key, required this.patronType});

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
  final TextEditingController _idnumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _OrganizationalController = TextEditingController();

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
    _idnumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _OrganizationalController.dispose();
    super.dispose();
  }

  // Function to load campuses from API
  Future<void> _loadCampuses() async {
    setState(() => _isCampusesLoading = true);

    final result = await FetchDataService.getCampuses();

    if (result['error'] == false) {
      final campuses = result['data']['data'] ?? [];

      setState(() {
        _campuses = List<Map<String, dynamic>>.from(campuses);
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

  // Function to handle user registration
  Future<void> _registerUser() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedSex == null ||
        ((widget.patronType == 3 && _OrganizationalController.text.isEmpty) ||
          (widget.patronType == 3 && _selectedCampus == null))
    ) {
      ValidationDialogs.emptyField(context);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ValidationDialogs.passwordNotMatch(context);
      return;
    }

    setState(() => _isRegisterLoading = true);

    try {
      String sexValue = _selectedSex == 'Male' ? 'male' : 'female';

      final result = await ApiService.registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        sex: sexValue,
        // campusId: widget.patronType == 3 ? null : int.parse(_selectedCampus!),
        campusId: widget.patronType == 3 ? null : int.parse(_selectedCampus!),
        idnumber: _idnumberController.text.trim(),
        email: _emailController.text.trim(),
        role: '2', //means patron
        patronType: widget.patronType, //[1] Faculty [2] Student
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        organization: widget.patronType == 3 ? _OrganizationalController.text.trim() : null,
      );

      if (result['error'] == false) {
        final data = result['data'] ?? {};
        final String? token = data['access_token'] as String?;

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
              builder: (context) => AccountVerificationPage(
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

  String _passwordStrength = '';

  String _checkPasswordStrength(String password) {
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final hasMinLength = password.length >= 8;

    if (!hasMinLength) return "Too Short";
    if (hasUpper && hasLower && hasNumber && hasSpecial) return "Very Strong";
    if (hasUpper && hasLower && hasNumber) return "Strong";
    if ((hasUpper || hasLower) && hasNumber) return "Medium";
    return "Weak";
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Step indicator outside
      const Padding(
        padding: EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          'Step 1 out of 3',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textColor,
          ),
        ),
      ),

      // Main form container
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First Name
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))
              ],
            ),
            const SizedBox(height: 16),

            // Last Name
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))
              ],
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
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

            const SizedBox(height: 20),

            // Continue button
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
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
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

            const SizedBox(height: 14),

            // ✅ "Already have an account?" BELOW the button
            Center(
              child: Row(
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
                            builder: (context) => const PatronLoginPage()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildStepTwo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          'Step 2 out of 3',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textColor,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 210, 241, 227),
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: AppColors.primaryGreen),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            (widget.patronType == 3)
              ? TextField(
                controller: _OrganizationalController,
                decoration: const InputDecoration( labelText: 'Organization Name: '),
                textCapitalization: TextCapitalization.words,
              )
            : // Campus dropdown
            _isCampusesLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCampus,
                      decoration:
                          const InputDecoration(labelText: 'Select Campus'),
                      items: _campuses
                          .map<DropdownMenuItem<String>>((campus) {
                        return DropdownMenuItem<String>(
                          value: campus['id'].toString(),
                          child: Text(campus['name'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCampus = val),
                    ),
                  ),

            const SizedBox(height: 16),

            // ID Number
            TextField(
              controller: _idnumberController,
              decoration: InputDecoration(labelText: 'ID Number'),
              inputFormatters: [
                TextInputFormatter.withFunction((oldInput, newInput){
                  final formattedText = newInput.text
                        .toUpperCase()
                        .replaceAll(' ', '');
                  return TextEditingValue(
                    text: formattedText,
                    selection: newInput.selection,
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              textCapitalization: TextCapitalization.none,
              inputFormatters: [
                TextInputFormatter.withFunction((oldInput, newInput) {
                  final formattedText = newInput.text
                      .toLowerCase()
                      .replaceAll(' ', ''); 
                  return TextEditingValue(
                    text: formattedText,
                    selection: newInput.selection,
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Continue to Step 3
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isEmpty ||
                    _selectedCampus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }
                setState(() => _step = 2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 20),
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
      ),
    ],
  );
}


Widget _buildStepThree() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          'Step 3 out of 3',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textColor,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 210, 241, 227),
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: AppColors.primaryGreen),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Password
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              onChanged: (value) {
                setState(() {
                  _passwordStrength = _checkPasswordStrength(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textColor,
                  ),
                  onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequirement( "At least 8 characters", _passwordController.text.length >= 8 ),
                _buildRequirement( "At least 1 uppercase letter", RegExp(r'[A-Z]').hasMatch(_passwordController.text )),
                _buildRequirement( "At least 1 lowercase letter", RegExp(r'[a-z]').hasMatch(_passwordController.text )),
                _buildRequirement( "At least 1 number", RegExp(r'[0-9]').hasMatch(_passwordController.text )),
                _buildRequirement( "At least 1 special character (Optional)", RegExp(r'[!@#\$&*~%^&+=]') .hasMatch(_passwordController.text ),
                  isOptional: true ),
              ],
            ),

            if (_passwordStrength.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _passwordStrength == "Too Short"
                          ? 0.2
                          : _passwordStrength == "Weak"
                              ? 0.4
                              : _passwordStrength == "Medium"
                                  ? 0.6
                                  : _passwordStrength == "Strong"
                                      ? 0.8
                                      : 1.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _passwordStrength == "Too Short"
                            ? Colors.red
                            : _passwordStrength == "Weak"
                                ? Colors.orange
                                : _passwordStrength == "Medium"
                                    ? Colors.yellow
                                    : _passwordStrength == "Strong"
                                        ? Colors.lightGreen
                                        : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _passwordStrength,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _passwordStrength == "Strong"
                          ? Colors.lightGreen
                          : _passwordStrength == "Medium"
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Confirm password
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirm Password'),
            ),

            const SizedBox(height: 24),

            // Sign Up button
            ElevatedButton(
              onPressed: _isRegisterLoading
                  ? null
                  : (_passwordStrength == "Strong" ||
                          _passwordStrength == "Very Strong")
                      ? _registerUser
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: _isRegisterLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.backgroundColor),
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
      ),
    ],
  );
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  (_step == 1 || _step == 2)
          ? AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.primaryGreen),
                onPressed: () => setState(() => _step = _step - 1),
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
                    children: 
                    [
                      _buildStepOne(),
                      _buildStepTwo(),
                      _buildStepThree(),
                    ]
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isValid, {bool isOptional = false}) {
  Color color;
  IconData icon;

  if (isValid) {
    color = Colors.green;
    icon = Icons.check_circle;
  } else if (isOptional) {
    color = Colors.orange; // yellow/orange if optional & missing
    icon = Icons.info_outline;     // info icon to indicate optional
  } else {
    color = Colors.red;
    icon = Icons.cancel;
  }

  return Row(
    children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13,
        ),
      ),
    ],
  );
}

}
