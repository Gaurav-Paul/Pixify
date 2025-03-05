import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/pages/chat_page.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatefulWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  const UserInfoCard({
    super.key,
    required this.currentDatabaseSnapshot,
    required this.userID,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late final List listOfFollowedUsers;

  late final List listOfFollowingUsers;

  late final List listOfPosts;

  @override
  void initState() {
    super.initState();
    // list of followed
    try {
      listOfFollowedUsers = (widget.currentDatabaseSnapshot
              .child('users')
              .child(widget.userID)
              .child('following')
              .value as Map)
          .values
          .toList();
    } catch (e) {
      listOfFollowedUsers = (widget.currentDatabaseSnapshot
          .child('users')
          .child(widget.userID)
          .child('following')
          .value as List);
    }

    // list of followers
    try {
      listOfFollowingUsers = (widget.currentDatabaseSnapshot
              .child('users')
              .child(widget.userID)
              .child('followers')
              .value as Map)
          .values
          .toList();
    } catch (e) {
      listOfFollowingUsers = (widget.currentDatabaseSnapshot
          .child('users')
          .child(widget.userID)
          .child('followers')
          .value as List);
    }


    // list of posts
    try {
      listOfPosts = (widget.currentDatabaseSnapshot
              .child('users')
              .child(widget.userID)
              .child('posts')
              .value as Map)
          .values
          .toList();
    } catch (e) {
      listOfPosts = (widget.currentDatabaseSnapshot
          .child('users')
          .child(widget.userID)
          .child('posts')
          .value as List);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: !(widget.currentDatabaseSnapshot
                          .child('users')
                          .child(widget.userID)
                          .child('active')
                          .value as bool)
                      ? ProfilePicCircle(
                          profilePicURL: widget.currentDatabaseSnapshot
                              .child('users')
                              .child(widget.userID)
                              .child('profilePicURL')
                              .value
                              .toString(),
                          bigCircleRadius: 50,
                          imageCircleRadius: 48,
                        )
                      : Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ProfilePicCircle(
                              profilePicURL: widget.currentDatabaseSnapshot
                                  .child('users')
                                  .child(widget.userID)
                                  .child('profilePicURL')
                                  .value
                                  .toString(),
                              bigCircleRadius: 50,
                              imageCircleRadius: 48,
                            ),
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                            )
                          ],
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  overflow: TextOverflow.ellipsis,
                  widget.currentDatabaseSnapshot
                      .child('users')
                      .child(widget.userID)
                      .child('username')
                      .value
                      .toString(),
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            const SizedBox(width: 50),
            Expanded(
              child: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Followers:\n${listOfFollowingUsers.length - 1}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Posts:\n${listOfPosts.length - 1}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StreamProvider.value(
                                            value: DatabaseService.database
                                                .ref('users')
                                                .child(AuthService
                                                    .auth.currentUser!.uid)
                                                .child('chats')
                                                .child(widget.userID)
                                                .child('messages')
                                                .orderByChild('timeSent')
                                                .onValue,
                                            initialData: null,
                                            child: ChatPage(
                                                currentDatabaseSnapshot: widget
                                                    .currentDatabaseSnapshot,
                                                userID: widget.userID),
                                          )),
                                ),
                            icon: const Icon(Icons.chat))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Text(
              "Following:\n${listOfFollowedUsers.length - 1}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
