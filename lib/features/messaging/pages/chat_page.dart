import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/components/chat_bubble.dart';
import 'package:pixify/features/messaging/components/chat_text_field.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  const ChatPage({
    super.key,
    required this.currentDatabaseSnapshot,
    required this.userID,
  });

  String calculateTimeDifferenceMessage(Duration differenceDuration) {
    return differenceDuration.inSeconds > 59
        ? differenceDuration.inMinutes > 59
            ? differenceDuration.inHours > 23
                ? "was active ${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? "day" : "days"} ago"
                : "was active ${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? "hour" : "hours"} ago"
            : "was active ${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? "minute" : "minutes"} ago"
        : "was active a Few moments ago";
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseEvent? messagesEvent = Provider.of<DatabaseEvent?>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: messagesEvent == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Scaffold(
              appBar: AppBar(
                leadingWidth: 30,
                title: Row(
                  children: [
                    !(currentDatabaseSnapshot
                            .child('users')
                            .child(userID)
                            .child('active')
                            .value as bool)
                        ? ProfilePicCircle(
                            profilePicURL: currentDatabaseSnapshot
                                .child('users')
                                .child(userID)
                                .child('profilePicURL')
                                .value
                                .toString(),
                          )
                        : Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ProfilePicCircle(
                                profilePicURL: currentDatabaseSnapshot
                                    .child('users')
                                    .child(userID)
                                    .child('profilePicURL')
                                    .value
                                    .toString(),
                              ),
                              const Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 15,
                              )
                            ],
                          ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentDatabaseSnapshot
                              .child('users')
                              .child(userID)
                              .child('username')
                              .value
                              .toString(),
                        ),
                        (currentDatabaseSnapshot
                                .child('users')
                                .child(userID)
                                .child('active')
                                .value as bool)
                            ? const Text(
                                'Online',
                                style: TextStyle(fontSize: 13),
                              )
                            : Text(
                                calculateTimeDifferenceMessage(
                                  DateTime.now().difference(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          currentDatabaseSnapshot
                                              .child('users')
                                              .child(userID)
                                              .child('lastSeen')
                                              .value as int)),
                                ),
                                style: const TextStyle(fontSize: 13),
                              )
                      ],
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  !(messagesEvent.snapshot.exists)
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              "Send a message and start a conversation!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: messagesEvent.snapshot.exists
                                ? messagesEvent.snapshot.children.length
                                : 1,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: messagesEvent.snapshot.children
                                            .toList()[index]
                                            .child('senderId')
                                            .value
                                            .toString() ==
                                        AuthService.auth.currentUser!.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: ChatBubble(
                                  message: messagesEvent.snapshot.children
                                      .toList()[index]
                                      .child('textMessage')
                                      .value
                                      .toString(),
                                  isOwner: messagesEvent.snapshot.children
                                          .toList()[index]
                                          .child('senderId')
                                          .value
                                          .toString() ==
                                      AuthService.auth.currentUser!.uid,
                                ),
                              );
                            },
                          ),
                        ),
                  ChatTextField(recieverUID: userID)
                ],
              ),
            ),
    );
  }
}
