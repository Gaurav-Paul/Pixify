import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/services/auth_service.dart';
import 'package:pixify/supabase_initializer.dart';
import 'package:pixify/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initializeSupabaseAPI();

  runApp(
    const AppRoot(),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: AuthService.auth.authStateChanges(),
          builder: (context, snapshot) {
            return const Wrapper();
          }),
    );
  }
}
