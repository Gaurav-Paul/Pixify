import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/services/database_service.dart';

class FollowButton extends StatefulWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  final List listOfFollowedUsers;
  const FollowButton({
    super.key,
    required this.userID,
    required this.currentDatabaseSnapshot,
    required this.listOfFollowedUsers,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool? following;
  bool loading = false;

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

  @override
  Widget build(BuildContext context) {
    return !loading
        ? TextButton(
            onPressed: () => followOrUnFollow(
                context: context,
                follow: widget.listOfFollowedUsers.contains(widget.userID)
                    ? false
                    : true),
            child:
                following ?? widget.listOfFollowedUsers.contains(widget.userID)
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
          );
  }
}
