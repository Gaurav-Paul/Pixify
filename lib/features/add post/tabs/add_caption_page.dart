import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pixify/features/add%20post/components/add_post_text_field.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';

class AddCaptionPage extends StatelessWidget {
  final File selectedImageFile;
  AddCaptionPage({
    super.key,
    required this.selectedImageFile,
  });

  final TextEditingController captionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 100),
              AddPostTextField(
                controller: captionController,
                postType: 'image',
              ),
              const SizedBox(height: 30),
              FloatingActionButton.extended(
                onPressed: () {
                  if (!(formKey.currentState!.validate())) {
                    return;
                  }

                  Navigator.of(context).pop();

                  Navigator.of(context).pop();
                  DatabaseService().addImagePost(
                    imageFile: selectedImageFile,
                    context: context,
                    authorID: AuthService.auth.currentUser!.uid,
                    postDate: DateTime.now(),
                    text: captionController.text.isEmpty
                        ? null
                        : captionController.text,
                  );
                },
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black87,
                label: const Text(
                  "Upload Post",
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
