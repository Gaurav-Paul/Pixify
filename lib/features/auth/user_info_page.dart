import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixify/features/auth/components/auth_text_field.dart';
import 'package:pixify/features/auth/components/image_selector.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:pixify/services/settings_service.dart';
import 'package:pixify/models/settings_model.dart';
import 'package:pixify/helper/show_alert_dialog.dart';

class UserInfoPage extends StatefulWidget {
  final String email;
  final String password;
  const UserInfoPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController usernameController = TextEditingController();

  File? selectedImage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  imageSelect() async {
    late final CroppedFile? croppedImageFile;
    final XFile? imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
      maxHeight: 750,
      maxWidth: 750,
    );

    if (imageFile != null) {
      croppedImageFile = await ImageCropper().cropImage(
        compressQuality: 45,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(aspectRatioPresets: [CropAspectRatioPreset.square])
        ],
        sourcePath: File(imageFile.path).path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
    } else {
      croppedImageFile = null;
    }

    if (mounted && croppedImageFile != null) {
      setState(
        () {
          selectedImage = File(croppedImageFile!.path);
        },
      );
    }
  }

  signUp() async {
    if (!(formKey.currentState!.validate()) ||
        usernameController.text.isEmpty) {
      return;
    }

    SettingsService.settingsStream.add(SettingsModel(
        isLoading: true, loadingText: 'Checking Username Availability...'));

    if (await DatabaseService()
        .isUsernameInUse(username: usernameController.text)) {
      showAlertDialog(
          context: context,
          content: "Username Already in Use..\n\nPlease try another username");
      return;
    }

    Navigator.of(context).pop();

    await AuthService().signUp(
      email: widget.email,
      password: widget.password,
      username: usernameController.text,
      profilePicFile: selectedImage,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: ListView(
              children: [
                // Spacing
                const SizedBox(height: 25),

                // Image Selection
                Center(
                    child: ImageSelector(
                  selectImageFunction: imageSelect,
                  imageFile: selectedImage,
                )),

                // Spacing
                const SizedBox(height: 75),

                // Username Field
                Form(
                  key: formKey,
                  child: AuthTextField(
                    obscureText: false,
                    labelText: 'Username',
                    controller: usernameController,
                    icon: Icons.account_circle,
                    validatorFunction: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(' ')) {
                        return "Invalid Username";
                      }
                      return null;
                    },
                  ),
                ),

                // Spacing
                const SizedBox(height: 50),

                // Sign Up button
                Card(
                  color: Colors.amber,
                  clipBehavior: Clip.hardEdge,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    splashColor: Colors.white38,
                    onTap: signUp,
                    child: const SizedBox(
                      height: 75,
                      width: 400,
                      child: Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
