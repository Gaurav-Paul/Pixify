import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostBlock extends StatelessWidget {
  final String authorID;
  final DataSnapshot postData;
  const PostBlock({
    super.key,
    required this.authorID,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Text(
          "authorID: $authorID\n\nPostID: ${postData.child("postID").value}",
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
