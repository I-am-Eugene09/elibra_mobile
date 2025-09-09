import 'package:flutter/material.dart';
import '../assets.dart';
import 'package:elibra_mobile/services/config_auth.dart';
// import 'package:flutter_svg/svg.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String token; // JWT for protected verify endpoint
  
  const OTPVerificationScreen({
    Key? key,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final int _otpLength = 6;
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _currentIndex = 0;
  bool _isVerifying = false;

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _currentIndex = i;
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_currentIndex < _otpLength) {
      setState(() {
        _otpControllers[_currentIndex].text = number;
        _onOTPChanged(number, _currentIndex);
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

  void _onOTPChanged(String value, int index) {
    setState(() {
      if (value.isNotEmpty) {
        if (index < _otpLength - 1) {
          _currentIndex = index + 1;
        }
      } else {
        if (index > 0) {
          _currentIndex = index - 1;
        }
      }
    });
    _tryVerifyIfComplete();
  }

  Future<void> _tryVerifyIfComplete() async {
    if (_enteredOtp.length != _otpLength || _isVerifying) return;
    setState(() {
      _isVerifying = true;
    });
    try {
      final result = await ApiService.verifyOTP(token: widget.token, otp: _enteredOtp);
      if (result['error'] == false) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Upper section with OTP input
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF8F9FA),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Image.asset(
                    'assets/images/OTP.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                ),
                ],
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
                        const TextSpan(text: 'OTP will be send to ur registered email '),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(fontStyle: FontStyle.italic),
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
                          margin: const EdgeInsets.symmetric(horizontal: 6),
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
                  // Resend OTP
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Handle resend OTP
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP resent successfully')),
                        );
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
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
                  // Numbers 1-3
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
                  // Numbers 4-6
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
                  // Numbers 7-9
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
                  // Number 0 and backspace
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildEmptyButton()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNumberButton('0')),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildBackspaceButton(),
                        ),
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
        decoration: BoxDecoration(
          color: Colors.transparent,
        //   borderRadius: BorderRadius.circular(12),
        ),
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
