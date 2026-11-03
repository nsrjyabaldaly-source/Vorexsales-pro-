import 'package:flutter/material.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/features/auth/login_screen.dart';

/// Registration is folded into the polished login continue-with-email flow.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      VxScope.of(context).openLogin();
    });
  }

  @override
  Widget build(BuildContext context) => const LoginScreen();
}
