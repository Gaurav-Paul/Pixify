import 'dart:async';
import 'package:pixify/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

SettingsModel settingsValues = SettingsModel(
  isLoading: false,
  loadingText: '',
);

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
        'isLoading': sharedPreferences.getBool('isLoading'),
        'loadingText': sharedPreferences.getString('loadingText'),
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
    sharedPreferences.setBool(
      "isLoading",
      settingsValues.isLoading,
    );
    sharedPreferences.setString(
      "loadingText",
      settingsValues.loadingText,
    );
  }
}
