import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/features/profile/profile_page.dart';
import 'package:pixify/services/database_service.dart';

class SearchUserTile extends StatefulWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  final List listOfFollowedUsers;
  const SearchUserTile(
      {super.key,
      required this.currentDatabaseSnapshot,
      required this.userID,
      required this.listOfFollowedUsers});

  @override
  State<SearchUserTile> createState() => _SearchUserTileState();
}

class _SearchUserTileState extends State<SearchUserTile> {
  followOrUnFollow({
    required bool follow,
    required BuildContext context,
  }) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    await DatabaseService()
        .toggleFollow(context: context, follow: follow, userID: widget.userID);
    if (mounted) {
      setState(() {
        loading = false;
        following = follow;
      });
    }
  }

  bool loading = false;
  bool? following;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(
                userID: widget.userID,
                currentDatabaseSnapshot: widget.currentDatabaseSnapshot))),
        leading: ProfilePicCircle(
          profilePicURL: widget.currentDatabaseSnapshot
              .child("users")
              .child(widget.userID)
              .child('profilePicURL')
              .value
              .toString(),
        ),
        title: Text(
          widget.currentDatabaseSnapshot
              .child("users")
              .child(widget.userID)
              .child('username')
              .value
              .toString(),
        ),
        trailing: !loading
            ? TextButton(
                onPressed: () => followOrUnFollow(
                    context: context,
                    follow: widget.listOfFollowedUsers.contains(widget.userID)
                        ? false
                        : true),
                child: following ??  widget.listOfFollowedUsers.contains(widget.userID)
                    ? const Text("Unfollow")
                    : const Text('Follow'),
              )
            : const SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              ),
      ),
    );
  }
}
