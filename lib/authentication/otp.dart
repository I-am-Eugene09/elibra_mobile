import 'dart:async';
import 'package:flutter/material.dart';
import '../assets.dart';
import 'package:elibra_mobile/services/config_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elibra_mobile/loading.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String userToken; // JWT for authentication
  final String otpToken;  // OTP token from backend

  const OTPVerificationScreen({
    Key? key,
    required this.email,
    required this.userToken,
    required this.otpToken,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final int _otpLength = 6;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());
  int _currentIndex = 0;
  bool _isVerifying = false;

  // Cooldown logic for resend
  bool _isCooldown = false;
  int _secondsLeft = 60;
  Timer? _timer;

  late String _otpToken;

  @override
  void initState() {
    super.initState();
    _otpToken = widget.otpToken;

    // Track current input index
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) _currentIndex = i;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) controller.dispose();
    for (var focusNode in _focusNodes) focusNode.dispose();
    super.dispose();
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text.trim()).join();

  // Start resend cooldown
  void _startCooldown() {
    setState(() {
      _isCooldown = true;
      _secondsLeft = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        setState(() => _isCooldown = false);
      }
    });
  }

  void _onNumberPressed(String number) {
    if (_currentIndex < _otpLength) {
      setState(() {
        _otpControllers[_currentIndex].text = number;
        if (_currentIndex < _otpLength - 1) _currentIndex++;
      });
      _tryVerifyIfComplete();
    }
  }

  void _onBackspacePressed() {
    setState(() {
      if (_currentIndex > 0 && _otpControllers[_currentIndex].text.isEmpty) {
        _currentIndex--;
      }
      _otpControllers[_currentIndex].text = '';
    });
  }

  // Auto-verify when all digits are entered
  Future<void> _tryVerifyIfComplete() async {
    if (_enteredOtp.length != _otpLength || _isVerifying) return;

    setState(() => _isVerifying = true);

    try {
      final result = await ApiService.verifyOTP(
        token: widget.userToken, // JWT
        otp: _enteredOtp,
        code: _otpToken,         // OTP token
      );

      if (result['error'] == false) {
        if (!mounted) return;
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token'); // optional
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Invalid OTP')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isVerifying = false);
    }
  }

  Future<void> _onResendOTP() async {
    _startCooldown();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const CustomLoadingModal(message: "Resending OTP..."),
    );

    try {
      final res = await ApiService.sendOTP(widget.email, widget.userToken);
      Navigator.pop(context);

      if (res['error'] == false) {
        setState(() {
          _otpToken = res['data']['token']; // update OTP token
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully. Check your email.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Failed to resend OTP.')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resending OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Upper section with OTP input
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF8F9FA),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/OTP.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          const TextSpan(
                              text:
                                  'OTP was sent to your registered email '),
                          TextSpan(
                            text: widget.email,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // OTP Input Fields
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_otpLength, (index) {
                          return Container(
                            width: 44,
                            height: 50,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9ECEF),
                              borderRadius: BorderRadius.circular(8),
                              border: _currentIndex == index
                                  ? Border.all(color: Colors.blue, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                _otpControllers[index].text,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: MouseRegion(
                        cursor: _isCooldown
                            ? SystemMouseCursors.basic
                            : SystemMouseCursors.click,
                        child: GestureDetector(
                        onTap: _isCooldown ? null : _onResendOTP,
                        child: Text(
                          _isCooldown
                              ? 'Resend OTP in $_secondsLeft s'
                              : 'Resend OTP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _isCooldown
                                ? Colors.grey
                                : AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lower section with numeric keypad
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF8F9FA),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildNumberButton('1')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('2')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('3')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildNumberButton('4')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('5')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('6')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildNumberButton('7')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('8')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('9')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildEmptyButton()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('0')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildBackspaceButton()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        height: 60,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspacePressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.black54,
            size: 26,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
