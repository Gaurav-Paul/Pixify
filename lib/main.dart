import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/services/auth_service.dart';
import 'package:pixify/features/services/settings_service.dart';
import 'package:pixify/features/settings/settings_model.dart';
import 'package:pixify/supabase_initializer.dart';
import 'package:pixify/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initializeSupabaseAPI();

  SettingsModel? storedSettings = SettingsModel.fromMap(
    await SettingsService.getStoredSettings(),
  );

  if (await SettingsService.getStoredSettings() == null) {
    await SettingsService.setBaseSettingsInSharedPref();
  }

  runApp(
    StreamProvider<SettingsModel>.value(
      value: SettingsService.settingsStream.stream,
      initialData: storedSettings ?? settingsValues,
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel currentSettings = Provider.of<SettingsModel>(context);

    return MaterialApp(
      themeMode: currentSettings.darkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: StreamProvider<User?>.value(
        initialData: AuthService.auth.currentUser,
        value: AuthService.auth.authStateChanges(),
        child: const Wrapper(),
      ),
    );
  }
}
