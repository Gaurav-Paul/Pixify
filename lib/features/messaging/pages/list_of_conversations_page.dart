import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/pages/chat_page.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class ListOfConversationsPage extends StatelessWidget {
  final DataSnapshot currentDatabaseSnapshot;
  const ListOfConversationsPage({
    super.key,
    required this.currentDatabaseSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    final DatabaseEvent? listOfConvos = Provider.of<DatabaseEvent?>(context);
    return listOfConvos == null
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
        : !(listOfConvos.snapshot.exists)
            ? const Center(
                child: Text("No Ongoing conversations..."),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: listOfConvos.snapshot.children.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StreamProvider.value(
                            value: DatabaseService.database
                                .ref('users')
                                .child(AuthService.auth.currentUser!.uid)
                                .child('chats')
                                .child(listOfConvos.snapshot.children
                                    .toList()
                                    .reversed
                                    .toList()[index]
                                    .key
                                    .toString())
                                .child('messages')
                                .orderByChild('timeSent')
                                .onValue,
                            initialData: null,
                            child: ChatPage(
                              currentDatabaseSnapshot: currentDatabaseSnapshot,
                              userID: listOfConvos.snapshot.children
                                  .toList()
                                  .reversed
                                  .toList()[index]
                                  .key
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                      leading: !(currentDatabaseSnapshot
                              .child('users')
                              .child(listOfConvos.snapshot.children
                                  .toList()
                                  .reversed
                                  .toList()[index]
                                  .key
                                  .toString())
                              .child('active')
                              .value as bool)
                          ? ProfilePicCircle(
                              profilePicURL: currentDatabaseSnapshot
                                  .child('users')
                                  .child(listOfConvos.snapshot.children
                                      .toList()
                                      .reversed
                                      .toList()[index]
                                      .key
                                      .toString())
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
                                      .child(listOfConvos.snapshot.children
                                          .toList()
                                          .reversed
                                          .toList()[index]
                                          .key
                                          .toString())
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
                            .child(listOfConvos.snapshot.children
                                .toList()
                                .reversed
                                .toList()[index]
                                .key
                                .toString())
                            .child('username')
                            .value
                            .toString(),
                      ),
                      subtitle: Text(
                        listOfConvos.snapshot.children
                            .toList()
                            .reversed
                            .toList()[index]
                            .child('lastMessage')
                            .value
                            .toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chat),
                    ),
                  );
                },
              );
  }
}
