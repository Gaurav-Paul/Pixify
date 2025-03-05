import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/pages/add_contacts_page.dart';
import 'package:pixify/features/messaging/pages/list_of_conversations_page.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  final DataSnapshot currentDatabaseSnapshot;
  const MessagesPage({
    super.key,
    required this.currentDatabaseSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              "All Ongoing Chats",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18,
              ),
            ),
            floating: true,
            elevation: 2,
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) => StreamProvider<DatabaseEvent?>.value(
                value: DatabaseService.database
                    .ref('users')
                    .child(AuthService.auth.currentUser!.uid)
                    .child("chats")
                    .orderByChild("timeSent")
                    .onValue,
                initialData: null,
                child: ListOfConversationsPage(
                  currentDatabaseSnapshot: currentDatabaseSnapshot,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StreamProvider.value(
              value: DatabaseService.getEntireDatabaseStream(),
              initialData: null,
              child: AddContactsPage(),
            ),
          ),
        ),
        splashColor: Colors.white30,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, size: 28),
      ),
    );
  }
}
