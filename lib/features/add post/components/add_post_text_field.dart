import 'package:flutter/material.dart';

class AddPostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validatorFunction;
  final String postType;
  const AddPostTextField({
    super.key,
    required this.controller,
    required this.validatorFunction,
    required this.postType,
  });

  @override
  Widget build(BuildContext context) {
    // Only Text text field (Tweet Style)
    return postType == 'textOnly'
        ? TextFormField(
            controller: controller,
            validator: validatorFunction,
            minLines: 10,
            maxLines: 20,
            autofocus: false,
            maxLength: 512,

            //
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.amber),
              hintText: "Enter Your Text Here...",

              //
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.amber, width: 1),
              ),

              //
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.amber, width: 1),
              ),

              //
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.amber, width: 1.5),
              ),
              //
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red, width: 1)),

              //
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5)),
            ),
          )

        // Caption Text Field (Insta Style)
        : TextFormField(
            controller: controller,
            validator: validatorFunction,
          );
  }
}
