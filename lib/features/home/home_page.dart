import 'package:flutter/material.dart';
import 'package:pixify/features/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => AuthService().signOut(context: context),
          child: const Text("Sign Out"),
        ),
      ),
    );
  }
}
