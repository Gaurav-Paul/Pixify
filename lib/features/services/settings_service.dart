import 'dart:async';
import 'package:pixify/features/settings/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

SettingsModel settingsValues = SettingsModel(darkTheme: true);

class SettingsService {
  static final StreamController<SettingsModel> settingsStream =
      StreamController<SettingsModel>.broadcast();

  static void initState() {
    settingsStream.add(settingsValues);
  }

  static void updateSettingsStream({
    required SettingsModel settingsValues,
  }) {
    settingsStream.add(settingsValues);
  }

  static Future<Map<String, dynamic>?> getStoredSettings() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final Map<String, dynamic> finalMap = {
        'darkTheme': sharedPreferences.getBool('darkTheme'),
      };
      if (finalMap.values.contains(null)) {
        throw "no shared preference set!!!";
      }
      return finalMap;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future setBaseSettingsInSharedPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("darkTheme", settingsValues.darkTheme);
  }
}
