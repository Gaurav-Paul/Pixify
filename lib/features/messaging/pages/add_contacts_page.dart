import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/components/users_contact_list_tile.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:provider/provider.dart';

class AddContactsPage extends StatelessWidget {
  AddContactsPage({
    super.key,
  });

  final currentUserUID = AuthService.auth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final DatabaseEvent? currentDatabaseEvent =
        Provider.of<DatabaseEvent?>(context);
    if (currentDatabaseEvent == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
      );
    }

    final DataSnapshot currentDatabaseSnapshot = currentDatabaseEvent.snapshot;

    final List listOfUsersInContact = (currentDatabaseSnapshot
        .child('users')
        .child(currentUserUID)
        .child('conversations')
        .value as List);

    final List listOfUsersNotInContact = ((currentDatabaseSnapshot
            .child('all users')
            .value as Map)
        .keys
        .toList())
      ..removeWhere((element) =>
          listOfUsersInContact.contains(element) || element == currentUserUID);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${listOfUsersInContact.length - 1} ${listOfUsersInContact.length - 1 == 1 ? "User" : "Users"} In Contact",
              style: const TextStyle(fontSize: 18, color: Colors.amber),
            ),
            Text(
              "${listOfUsersNotInContact.length} ${listOfUsersNotInContact.length == 1 ? "User" : "Users"} Not In Contact",
              style: const TextStyle(fontSize: 14, color: Colors.amber),
            )
          ],
        ),
      ),
      body: listOfUsersNotInContact.isEmpty
          ? const Center(
              child: Text("No Users left To start a conversation with"),
            )
          : ListView.builder(
              itemCount: listOfUsersNotInContact.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const ListTile(
                    title: Center(
                        child: Text(
                            "Start a chat with one of the following Users!")),
                    subtitle: Divider(color: Colors.amber),
                  );
                } else {
                  return UsersContactListTile(
                    userID: listOfUsersNotInContact[index - 1],
                    currentDatabaseSnapshot: currentDatabaseSnapshot,
                  );
                }
              },
            ),
    );
  }
}
