import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/auth/login_or_register.dart';
import 'package:pixify/features/home/home_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    return user == null ? const LoginOrRegister() : const HomePage();
  }
}
