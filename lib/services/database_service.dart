import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/constant_values.dart';
import 'package:pixify/services/settings_service.dart';
import 'package:pixify/services/storage_service.dart';
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

      await database.ref('all users').update({uid: username});

      SettingsService.settingsStream.add(
        SettingsModel(
            isLoading: true, loadingText: "Registered you in the database"),
      );

      SettingsService.settingsStream.add(
        SettingsModel(isLoading: false, loadingText: ""),
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

  Future<bool> isUsernameInUse({
    required String username,
  }) async {
    final DataSnapshot allUsersDataSnapshot =
        await database.ref('all users').get();

    if (!(allUsersDataSnapshot.exists)) {
      return false;
    }

    final Map allUsersMap = allUsersDataSnapshot.value as Map;
    return allUsersMap.values.contains(username);
  }

  static Stream<DatabaseEvent> getEntireDatabaseStream() {
    return database.ref(null).onValue.asBroadcastStream();
  }

  Future<void> addTextOnlyPost({
    required String text,
    required String authorID,
    required DateTime postDate,
    required BuildContext context,
  }) async {
    try {
      SettingsService.settingsStream.add(SettingsModel(
          isLoading: true,
          loadingText: 'Uploading Your post.\nDont close the App'));

      final String postID =
          "$authorID ${(await database.ref('users').child(authorID).child("posts").get()).children.length}";

      await database
          .ref('users')
          .child(authorID)
          .child("posts")
          .child(postID)
          .set(
        {
          'postID': postID,
          "uid": authorID,
          'type': "text",
          'date': postDate.microsecondsSinceEpoch.toString(),
          'text': text,
          'likedBy': ['placeHolder'],
        },
      );

      await database.ref('all posts').update(
        {
          postID: authorID,
        },
      );

      SettingsService.settingsStream.add(SettingsModel(
          isLoading: true, loadingText: 'Done Uploading Your post!'));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));
    } catch (e) {
      SettingsService.settingsStream.add(
          SettingsModel(isLoading: true, loadingText: 'An Error Occured!'));

      SettingsService.settingsStream
          .add(SettingsModel(isLoading: false, loadingText: ''));

      showAlertDialog(context: context, content: e.toString());
    }
  }

  likePost(
      {required String postID,
      required String authorUID,
      required String currentUserUID}) async {
    int no_of_likes = (await database
            .ref('users')
            .child(authorUID)
            .child("posts")
            .child(postID)
            .child('likedBy')
            .get())
        .children
        .length;
    await database
        .ref('users')
        .child(authorUID)
        .child("posts")
        .child(postID)
        .child('likedBy')
        .update({no_of_likes.toString(): currentUserUID});
  }

  dislikePost({
    required String postID,
    required int keyToRemove,
    required String authorUID,
  }) async {
    await database
        .ref('users')
        .child(authorUID)
        .child('posts')
        .child(postID)
        .child('likedBy')
        .child(keyToRemove.toString())
        .remove();
  }
}
