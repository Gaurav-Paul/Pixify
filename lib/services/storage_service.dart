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

  Future<String?> uploadImageForPost({
    required BuildContext context,
    required String authorID,
    required File imageFile,
    required String postID,
  }) async {
    try {
      await storage.from('posts').upload('$authorID/$postID', imageFile);

      return storage.from('posts').getPublicUrl('$authorID/$postID');
    } catch (e) {

      print(e.toString());
      SettingsService.settingsStream.add(
          SettingsModel(isLoading: true, loadingText: 'An Error Occured!'));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));

      showAlertDialog(context: context, content: e.toString());
      return null;
    }
  }
}
