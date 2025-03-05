import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/profile/components/image_post_grid.dart';
import 'package:pixify/features/profile/components/text_post_grid.dart';
import 'package:pixify/features/profile/components/user_info_card.dart';
import 'package:pixify/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  const ProfilePage({
    super.key,
    required this.userID,
    required this.currentDatabaseSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: userID == AuthService.auth.currentUser!.uid
            ? [
                IconButton(
                  onPressed: () => AuthService().signOut(context: context),
                  icon: const Icon(Icons.logout),
                )
              ]
            : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoCard(
            currentDatabaseSnapshot: currentDatabaseSnapshot,
            userID: userID,
          ),
          const SizedBox(height: 35),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.amber,
                    indicatorColor: Colors.amber,
                    tabs: [
                      Text(
                          "${userID == AuthService.auth.currentUser!.uid ? "Your " : ''}Thoughts.."),
                      Text(
                          "${userID == AuthService.auth.currentUser!.uid ? "Your " : ''}Pics"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      dragStartBehavior: DragStartBehavior.down,
                      children: [
                        TextPostGrid(
                          currentDatabaseSnapshot: currentDatabaseSnapshot,
                          userID: userID,
                        ),
                        ImagePostGrid(
                          currentDatabaseSnapshot: currentDatabaseSnapshot,
                          userID: userID,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
