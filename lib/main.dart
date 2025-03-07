import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixify/features/content%20wrapper/content_wrapper.dart';
import 'package:pixify/features/loading/loading_screen.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:pixify/services/notification_service.dart';
import 'package:pixify/services/settings_service.dart';
import 'package:pixify/models/settings_model.dart';
import 'package:pixify/supabase_initializer.dart';
import 'package:pixify/wrapper.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initializeSupabaseAPI();

  await NotificationService().initNotification();

  SettingsModel? storedSettings = SettingsModel.fromMap(
    await SettingsService.getStoredSettings(),
  );

  if (await SettingsService.getStoredSettings() == null) {
    await SettingsService.setBaseSettingsInSharedPref();
  }

  // Locks App to Portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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

    return MediaQuery.withNoTextScaling(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/messages-page-route': (context) => StreamProvider<DatabaseEvent?>.value(
            initialData: null,
            value: DatabaseService.getEntireDatabaseStream(),
            child: const ContentWrapper(page: 2),
          )
        },
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: currentSettings.isLoading
            ? LoadingScreen(loadingText: currentSettings.loadingText)
            : StreamProvider<User?>.value(
                initialData: AuthService.auth.currentUser,
                value: AuthService.auth.authStateChanges(),
                child: const Wrapper(),
              ),
      ),
    );
  }
}
