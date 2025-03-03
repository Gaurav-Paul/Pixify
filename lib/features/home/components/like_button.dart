import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';

class LikeButton extends StatefulWidget {
  final DataSnapshot postData;
  LikeButton({
    super.key,
    required this.postData,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool loading = false;
  DatabaseService database = DatabaseService();

  addOrRemovePostLike() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final bool isLiked = (widget.postData.child('likedBy').value! as List)
        .contains(AuthService.auth.currentUser!.uid);

    if (!isLiked) {
      await database.likePost(
          postID: widget.postData.child('postID').value.toString(),
          authorUID: widget.postData.child('uid').value.toString(),
          currentUserUID: AuthService.auth.currentUser!.uid);
    } else {
      await database.dislikePost(
          postID: widget.postData.child('postID').value.toString(),
          authorUID: widget.postData.child('uid').value.toString(),
          keyToRemove: (widget.postData.child('likedBy').value! as List)
              .indexOf(AuthService.auth.currentUser!.uid));
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : IconButton(
            onPressed: addOrRemovePostLike,
            icon: (widget.postData
                    .child('likedBy')
                    .value
                    .toString()
                    .contains(AuthService.auth.currentUser!.uid))
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_outline_outlined),
          );
  }
}
