import 'dart:io';

import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final File? imageFile;
  final VoidCallback selectImageFunction;
  const ImageSelector({
    super.key,
    this.imageFile,
    required this.selectImageFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 160,
          backgroundColor: Colors.amber,
          child: CircleAvatar(
            radius: 150,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundImage: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ).image
                : null,
            child: imageFile == null
                ? const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 175,
                  )
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 15.0,
            bottom: 15.0,
          ),
          child: FloatingActionButton(
            splashColor: Colors.white38,
            shape: const CircleBorder(),
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black87,
            onPressed: selectImageFunction,
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}
