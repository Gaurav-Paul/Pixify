import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/home/components/like_button.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/features/search/components/follow_button.dart';

class PostBlock extends StatelessWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final DataSnapshot postData;
  final bool? isOwner;
  final List? listOfFollowedUsers;
  const PostBlock({
    super.key,
    required this.postData,
    required this.currentDatabaseSnapshot,
    this.isOwner,
    this.listOfFollowedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          // author Info
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: ProfilePicCircle(
              profilePicURL:
                  "${currentDatabaseSnapshot.child("users").child('${postData.child('uid').value}').child("profilePicURL").value}",
            ),
            title: Text(
                "${currentDatabaseSnapshot.child("all users").child('${postData.child('uid').value}').value}"),
            trailing: isOwner ?? false
                ? const SizedBox()
                : FollowButton(
                    userID: postData.child('uid').value.toString(),
                    currentDatabaseSnapshot: currentDatabaseSnapshot,
                    listOfFollowedUsers: listOfFollowedUsers!),
          ),
          const SizedBox(height: 15),

          //content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: postData.child('type').value.toString() == "text"
                      ? Text(postData.child('text').value.toString())
                      : Card(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            height: 300,
                            width: 300,
                            child: Image.network(
                              fit: BoxFit.contain,
                              postData.child('imageURL').value.toString(),
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress != null
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!,
                                                color: Colors.amber,
                                              ),
                                            )
                                          : child,
                            ),
                          ),
                        ),
                ),
                isOwner ?? false
                    ? const SizedBox()
                    : LikeButton(postData: postData)
              ],
            ),
          ),
          postData.child('type').value.toString() == 'image' &&
                  postData.child('text').value.toString().isNotEmpty
              ? const SizedBox(height: 15)
              : const SizedBox(),
          postData.child('type').value.toString() == 'image' &&
                  postData.child('text').value.toString().isNotEmpty
              ? Text(postData.child('text').value.toString())
              : const SizedBox(),
          const Divider(),
        ],
      ),
    );
  }
}
