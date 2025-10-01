import 'package:elibra_mobile/authentication/patron_login.dart';
import 'package:flutter/material.dart';
import 'user_services.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _loading = true;
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final ok = await UserService.checkAuth();
    setState(() {
      _authenticated = ok;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_authenticated) {
      // redirect to login
      return const PatronLoginPage();
    }
    return widget.child;
  }
}
