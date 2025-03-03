import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/home/components/like_button.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';

class PostBlock extends StatelessWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final DataSnapshot postData;
  const PostBlock({
    super.key,
    required this.postData,
    required this.currentDatabaseSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: ProfilePicCircle(
              profilePicURL:
                  "${currentDatabaseSnapshot.child("users").child('${postData.child('uid').value}').child("profilePicURL").value}",
            ),
            title: Text(
                "${currentDatabaseSnapshot.child("all users").child('${postData.child('uid').value}').value}"),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: postData.child('type').value.toString() == "text"
                      ? Text(postData.child('text').value.toString())
                      : Image.network(
                          fit: BoxFit.contain,
                          postData.child('imageURL').value.toString(),
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress != null
                                  ? CircularProgressIndicator(
                                      value: loadingProgress
                                              .cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!,
                                      color: Colors.amber,
                                    )
                                  : child,
                        ),
                ),
                LikeButton(postData: postData)
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
