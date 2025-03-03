import 'package:flutter/material.dart';
import 'package:pixify/features/add%20post/components/add_post_text_field.dart';
import 'package:pixify/helper/show_alert_dialog.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';

class TextOnlyTab extends StatelessWidget {
  TextOnlyTab({super.key});

  final String currentUserUID = AuthService.auth.currentUser!.uid;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController textOnlyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            children: [
              // Spacing
              const SizedBox(height: 75),
              const Text(
                "What's On your Mind?",
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 50),
              AddPostTextField(
                controller: textOnlyController,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return "Needs to be at least 1 character long";
                  } else if (value.length > 512) {
                    return "Too Many Character. maximum of 512 allowed";
                  }
                  if ((value.split('')..removeWhere((char) => char == ' '))
                          .toString() ==
                      '[]') {
                    return 'Posts Cannot contain purely whitespace';
                  }

                  return null;
                },
                postType: 'textOnly',
              ),

              // Spacing
              const SizedBox(height: 25),

              // Upload Post Buton
              SizedBox(
                width: 450,
                height: 65,
                child: Card(
                  shape: const StadiumBorder(),
                  color: Colors.amber,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.white30,
                    onTap: () async {
                      if (!(formKey.currentState!.validate())) {
                        return;
                      }
                      if (textOnlyController.text.isEmpty) {
                        showAlertDialog(
                            context: context,
                            content:
                                "Enter Something in the Text Field To post...");
                      }
                      DatabaseService().addTextOnlyPost(
                        text: textOnlyController.text,
                        authorID: currentUserUID,
                        postDate: DateTime.now(),
                        context: context,
                      );
                    },
                    child: const Center(
                      child: Text(
                        "Upload Post",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 36,
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
    );
  }
}
