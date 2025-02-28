import 'package:flutter/material.dart';

showAlertDialog({required BuildContext context, required String content}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Ok"),
        ),
      ],
    ),
  );
}
