import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/auth/login_or_register.dart';
import 'package:pixify/features/content%20wrapper/content_wrapper.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    return user == null
        ? const LoginOrRegister()
        : StreamProvider<DatabaseEvent?>.value(
            initialData: null,
            value: DatabaseService.getEntireDatabaseStream(),
            child: const ContentWrapper(),
          );
  }
}
