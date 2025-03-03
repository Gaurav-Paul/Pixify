import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pixify/services/settings_service.dart';
import 'package:pixify/features/settings/settings_model.dart';
import 'package:pixify/helper/show_alert_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static final SupabaseStorageClient storage = Supabase.instance.client.storage;

  Future<String?> uploadProfilePic({
    required String uid,
    required String username,
    required File profilePicFile,
    required BuildContext context,
  }) async {
    try {
      await storage
          .from('profile Pics')
          .upload('$uid/$username', profilePicFile);
      return storage.from('profile Pics').getPublicUrl('$uid/$username');
    } catch (e) {
      SettingsService.settingsStream.add(
        SettingsModel(
            isLoading: true, loadingText: "Failed to upload your profile pic!"),
      );

      showAlertDialog(context: context, content: e.toString());

      return null;
    }
  }
}
