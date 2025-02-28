import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/services/database_service.dart';
import 'package:pixify/features/services/settings_service.dart';
import 'package:pixify/features/settings/settings_model.dart';
import 'package:pixify/helper/show_alert_dialog.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      SettingsService.settingsStream.add(
        SettingsModel(
            isLoading: true, loadingText: 'Attempting to sign you In!'),
      );

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SettingsService.settingsStream.add(
          SettingsModel(isLoading: true, loadingText: "You're signed In!"));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));

      return userCredential.user;
    } catch (e) {
      SettingsService.settingsStream.add(
          SettingsModel(isLoading: true, loadingText: "Failed to sign In!"));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));

      showAlertDialog(context: context, content: e.toString());

      return null;
    }
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String username,
    required File? profilePicFile,
    required BuildContext context,
  }) async {
    try {
      SettingsService.settingsStream.add(
        SettingsModel(
            isLoading: true, loadingText: "Attempting to Sign you up!"),
      );

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      DatabaseService().setUserBaseValues(
        email: email,
        uid: userCredential.user!.uid,
        username: username,
        profilePicFile: profilePicFile,
        context: context,
      );

      return userCredential.user;
    } catch (e) {
      SettingsService.settingsStream.add(
          SettingsModel(isLoading: true, loadingText: "Failed to sign Up!"));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));

      showAlertDialog(context: context, content: e.toString());

      return null;
    }
  }

  signOut({
    required BuildContext context,
  }) async {
    try {
      SettingsService.settingsStream.add(SettingsModel(
          isLoading: true, loadingText: "Trying to sign you out..."));

      await auth.signOut();

      SettingsService.settingsStream.add(SettingsModel(
          isLoading: true, loadingText: "Succesfully Signed out!"));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ""));
    } catch (e) {
      SettingsService.settingsStream.add(
          SettingsModel(isLoading: true, loadingText: "Failed to sign Out!"));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));

      showAlertDialog(context: context, content: e.toString());
    }
  }
}
