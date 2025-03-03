import 'package:flutter/material.dart';

class AddPostImageSelector extends StatelessWidget {
  const AddPostImageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.amber,
      child: const Icon(
        Icons.image,
        size: 175,
      ),
    );
  }
}
