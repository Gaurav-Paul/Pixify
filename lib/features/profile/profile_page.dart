import 'package:flutter/material.dart';
import 'package:pixify/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => AuthService().signOut(context: context),
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
