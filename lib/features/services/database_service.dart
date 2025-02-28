import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/constant_values.dart';
import 'package:pixify/features/services/settings_service.dart';
import 'package:pixify/features/services/storage_service.dart';
import 'package:pixify/features/settings/settings_model.dart';
import 'package:pixify/helper/show_alert_dialog.dart';
import 'package:pixify/models/user_model.dart';

class DatabaseService {
  static final FirebaseDatabase database = FirebaseDatabase.instance
    ..refFromURL(
        'https://pixify-f1e57-default-rtdb.asia-southeast1.firebasedatabase.app/');

  setUserBaseValues({
    required String email,
    required String uid,
    required String username,
    required File? profilePicFile,
    required BuildContext context,
  }) async {
    try {
      String? profilePicURL = ConstantValues.defaultUserPic;

      if (profilePicFile != null) {
        SettingsService.settingsStream.add(
          SettingsModel(
              isLoading: true, loadingText: "Uploading your profile Pic"),
        );

        profilePicURL = await StorageService().uploadProfilePic(
              uid: uid,
              username: username,
              profilePicFile: profilePicFile,
              context: context,
            ) ??
            ConstantValues.defaultUserPic;
      }

      SettingsService.settingsStream.add(
        SettingsModel(
            isLoading: true, loadingText: "Registering you in the database"),
      );

      await database.ref('users').child(uid).set(
            UserModel(
                    username: username,
                    uid: uid,
                    email: email,
                    profilePicURL: profilePicURL,
                    posts: ['placeHolder'],
                    followers: ['placeHolder'],
                    following: ['placeHolder'],
                    isPrivate: false)
                .toMap(),
          );

      SettingsService.settingsStream.add(
        SettingsModel(
            isLoading: true, loadingText: "Registered you in the database"),
      );
    } catch (e) {
      SettingsService.settingsStream.add(
        SettingsModel(isLoading: true, loadingText: "Error Occured!"),
      );

      SettingsService.settingsStream.add(
        SettingsModel(isLoading: false, loadingText: ""),
      );

      
      showAlertDialog(context: context, content: e.toString());
    }
  }
}
