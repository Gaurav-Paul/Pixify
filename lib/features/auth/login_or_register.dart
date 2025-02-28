import 'package:flutter/material.dart';
import 'package:pixify/features/auth/login_page.dart';
import 'package:pixify/features/auth/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({
    super.key,
  });

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool isLoginPage = true;

  togglePage() {
    if (mounted) {
      setState(() {
        isLoginPage = !isLoginPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoginPage
        ? LoginPage(togglePage: togglePage)
        : RegisterPage(togglePage: togglePage);
  }
}
