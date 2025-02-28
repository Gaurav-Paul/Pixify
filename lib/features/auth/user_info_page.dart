import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixify/features/auth/components/auth_text_field.dart';
import 'package:pixify/features/auth/components/image_selector.dart';

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

  imageSelect() async {
    XFile? imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 750,
      maxWidth: 750,
    );
    if (mounted) {
      setState(() {
        selectedImage = imageFile != null ? File(imageFile.path) : null;
      });
    }
  }

  signUp() async {}

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
                Center(child: ImageSelector(selectImageFunction: imageSelect)),

                // Spacing
                const SizedBox(height: 75),

                // Username Field
                AuthTextField(
                  obscureText: false,
                  labelText: 'Username',
                  controller: usernameController,
                  icon: Icons.account_circle,
                  validatorFunction: (value) {
                    if (value == null || value.isEmpty || value.contains(' ')) {
                      return "Invalid Username";
                    }
                    return null;
                  },
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
                    onTap: () {},
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
