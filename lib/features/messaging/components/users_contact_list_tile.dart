import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/pages/chat_page.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class UsersContactListTile extends StatelessWidget {
  final String userID;
  final DataSnapshot currentDatabaseSnapshot;
  const UsersContactListTile({
    super.key,
    required this.userID,
    required this.currentDatabaseSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          // Green dot if user is active
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
      title: Text(
        currentDatabaseSnapshot
            .child('users')
            .child(userID)
            .child('username')
            .value
            .toString(),
      ),
      subtitle: Text(
        currentDatabaseSnapshot
            .child('users')
            .child(userID)
            .child('email')
            .value
            .toString(),
      ),
      trailing: IconButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StreamProvider<DatabaseEvent?>.value(
              value: DatabaseService.database
                  .ref('users')
                  .child(AuthService.auth.currentUser!.uid)
                  .child('chats')
                  .child(userID)
                  .child('messages')
                  .orderByChild('timeSent')
                  .onValue,
              initialData: null,
              child: ChatPage(
                currentDatabaseSnapshot: currentDatabaseSnapshot,
                userID: userID,
              ),
            ),
          ),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
