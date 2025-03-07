import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/constant_values.dart';
import 'package:pixify/features/add%20post/add_post_page.dart';
import 'package:pixify/features/home/components/post_block.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final DataSnapshot currentDatabaseSnapshot;
  const HomePage({
    super.key,
    required this.currentDatabaseSnapshot,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String currentUserUID = AuthService.auth.currentUser!.uid;

  List? listOfPosts;

  int noOfPostsShown = 15;

  Map? mapOfAllUserPosts;

  // recommendation functions

  showAllUserPosts() async {
    mapOfAllUserPosts =
        ((await DatabaseService.database.ref('all posts').get()).value as Map)
          ..removeWhere(
            (postID, authorID) => authorID == AuthService.auth.currentUser!.uid,
          );

    listOfPosts = mapOfAllUserPosts!.keys.toList(growable: true)
      ..shuffle(Random());

    setState(() {
      listOfPosts = listOfPosts;
      mapOfAllUserPosts = mapOfAllUserPosts;
      if (listOfPosts!.length < 15) {
        noOfPostsShown = listOfPosts!.length;
      }
    });
  }

  showfilteredPosts() async {
    late final List listOfFollowedUsers;

    // get followed Users list
    try {
      listOfFollowedUsers = ((await DatabaseService.database
                  .ref('users')
                  .child(AuthService.auth.currentUser!.uid)
                  .child('following')
                  .get())
              .value as List)
          .toSet()
          .toList(growable: true)
        ..remove('placeHolder');
    } catch (e) {
      listOfFollowedUsers = ((await DatabaseService.database
                  .ref('users')
                  .child(AuthService.auth.currentUser!.uid)
                  .child('following')
                  .get())
              .value as Map)
          .values
          .toSet()
          .toList(growable: true)
        ..remove('placeHolder');
    }

    final List listOfNotFollowedUsers =
        ((((await DatabaseService.database.ref('all users').get()).value
                as Map))
              ..removeWhere(
                (uid, username) =>
                    listOfFollowedUsers.contains(uid) ||
                    uid == AuthService.auth.currentUser!.uid,
              ))
            .keys
            .toSet()
            .toList(growable: true);

    final Map mapOfUsedPosts =
        ((await DatabaseService.database.ref('all posts').get()).value as Map)
          ..removeWhere(
            (postID, authorID) =>
                authorID == AuthService.auth.currentUser!.uid ||
                listOfNotFollowedUsers.contains(authorID),
          );

    listOfPosts = mapOfUsedPosts.keys.toSet().toList(growable: true);

    final Map mapOfUnusedPosts =
        ((await DatabaseService.database.ref('all posts').get()).value as Map)
          ..removeWhere(
            (postID, authorID) =>
                authorID == AuthService.auth.currentUser!.uid ||
                listOfFollowedUsers.contains(authorID),
          );

    mapOfAllUserPosts =
        ((await DatabaseService.database.ref('all posts').get()).value as Map)
          ..removeWhere(
            (postID, authorID) => authorID == AuthService.auth.currentUser!.uid,
          );

    if (mapOfUnusedPosts.isNotEmpty) {
      for (int i = 0; i < mapOfUsedPosts.length / 5; i++) {
        var randomPostID = (mapOfUnusedPosts.keys.toSet().toList(growable: true)
          ..shuffle(Random()))[0];
        while (listOfPosts!.contains(randomPostID)) {
          randomPostID = (mapOfUnusedPosts.keys.toSet().toList(growable: true)
            ..shuffle(Random()))[0];
        }
        listOfPosts!.add(randomPostID);
      }
    }

    setState(() {
      listOfPosts = listOfPosts;
      mapOfAllUserPosts = mapOfAllUserPosts;
      if (listOfPosts!.length < 15) {
        noOfPostsShown = listOfPosts!.length;
      }
    });
  }

  // reccomendation chooser

  recommendationChooser() async {
    late final List listOfFollowedUsers;

    // get followed Users list
    try {
      listOfFollowedUsers = ((await DatabaseService.database
                  .ref('users')
                  .child(AuthService.auth.currentUser!.uid)
                  .child('following')
                  .get())
              .value as List)
          .toSet()
          .toList(growable: true)
        ..remove('placeHolder');
    } catch (e) {
      listOfFollowedUsers = ((await DatabaseService.database
                  .ref('users')
                  .child(AuthService.auth.currentUser!.uid)
                  .child('following')
                  .get())
              .value as Map)
          .values
          .toSet()
          .toList(growable: true)
        ..remove('placeHolder');
    }

    final List listOfNotFollowedUsers =
        ((((await DatabaseService.database.ref('all users').get()).value
                as Map))
              ..removeWhere(
                (uid, username) =>
                    listOfFollowedUsers.contains(uid) ||
                    uid == AuthService.auth.currentUser!.uid,
              ))
            .keys
            .toSet()
            .toList(growable: true);

    mapOfAllUserPosts =
        ((await DatabaseService.database.ref('all posts').get()).value as Map)
          ..removeWhere(
            (postID, authorID) => authorID == AuthService.auth.currentUser!.uid,
          );

    if (mapOfAllUserPosts!.isEmpty) {
      setState(() {
        listOfPosts = [];

        mapOfAllUserPosts = {};

        noOfPostsShown = 1;
      });
    }

    if (listOfFollowedUsers.isEmpty || listOfNotFollowedUsers.isEmpty) {
      showAllUserPosts();
    } else {
      showfilteredPosts();
    }
  }

  @override
  void initState() {
    recommendationChooser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DataSnapshot currentDatabaseSnapshot =
        (Provider.of<DatabaseEvent>(context)).snapshot;

    List listOfFollowedUsers;

    // get followed Users list
    try {
      listOfFollowedUsers = (currentDatabaseSnapshot.value as List)
          .toSet()
          .toList(growable: true)
        ..remove('placeHolder');
    } catch (e) {
      listOfFollowedUsers = (currentDatabaseSnapshot.value as Map)
          .values
          .toSet()
          .toList(growable: true)
        ..remove('placeHolder');
    }

    return listOfPosts == null || mapOfAllUserPosts == null
        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
        : Scaffold(
            appBar: AppBar(
              elevation: .2,
              title: Row(
                children: [
                  SizedBox(
                      height: 45,
                      width: 45,
                      child: FittedBox(
                          child: Image.network(ConstantValues.pixifyLens))),
                  const SizedBox(width: 10),
                  const Text(
                    "Pixify",
                    style: TextStyle(fontFamily: "Handwriting", fontSize: 36),
                  )
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddPostPage())),
                  style: IconButton.styleFrom(
                      iconSize: 20, foregroundColor: Colors.amber),
                  color: Colors.amber,
                  icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.amber, size: 30),
                    ),
                  ),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: noOfPostsShown,
              itemBuilder: (context, index) {
                return PostBlock(
                  postData: widget.currentDatabaseSnapshot
                      .child('users')
                      .child(mapOfAllUserPosts![listOfPosts![index]])
                      .child("posts")
                      .child(listOfPosts![index]),
                  currentDatabaseSnapshot: widget.currentDatabaseSnapshot,
                  listOfFollowedUsers: listOfFollowedUsers,
                );
              },
            ),
          );
  }
}
