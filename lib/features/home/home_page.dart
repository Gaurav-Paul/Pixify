import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/home/components/post_block.dart';
import 'package:pixify/features/loading/loading_screen.dart';
import 'package:pixify/services/auth_service.dart';

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

  // Various Reccomendation Functions:

  Future<void> notFilteredRecommendationFunction({
    required Map mapOfAllUserPosts,
  }) async {
    final List listOfAllPostIds = (mapOfAllUserPosts
          ..removeWhere(
            (key, value) => value == currentUserUID,
          ))
        .keys
        .toList()
        .toSet()
        .toList();

    if (mounted) {
      setState(
        () {
          listOfPosts = (listOfAllPostIds..shuffle(Random())).toSet().toList();
          mapOfAllUserPosts = mapOfAllUserPosts;
          if (noOfPostsShown > listOfPosts!.length) {
            noOfPostsShown = listOfPosts!.length;
          }
        },
      );
    }

    return;
  }

  Future<void> followingSomeUsersRecommendation({
    required Map mapOfAllUserPosts,
    required Map mapOfAllUsers,
    required List followedUsers,
  }) async {
    final List listOfAllPostIds = (mapOfAllUserPosts
          ..removeWhere(
            (key, value) =>
                value == currentUserUID ||
                !(followedUsers.contains(
                  value,
                )),
          ))
        .keys
        .toList()
        .toSet()
        .toList();

    final List listOfNotFollowedUsers = (mapOfAllUsers
          ..removeWhere((key, value) =>
              value == currentUserUID ||
              followedUsers.contains(
                value,
              )))
        .keys
        .toList()
        .toSet()
        .toList()
      ..shuffle();

    final List listOfNotFollowedUsersPosts = ((mapOfAllUserPosts)
          ..removeWhere((key, value) =>
              value == currentUserUID ||
              !(listOfNotFollowedUsers.contains(
                value,
              ))))
        .keys
        .toList()
        .toSet()
        .toList();

    print(listOfNotFollowedUsersPosts);

    for (int index = 0; index < listOfAllPostIds.length / 5; index++) {
      listOfAllPostIds.add(listOfNotFollowedUsersPosts[index]);
    }

    if (mounted) {
      setState(
        () {
          listOfPosts = (listOfAllPostIds..shuffle(Random())).toSet().toList();
          mapOfAllUserPosts = mapOfAllUserPosts;
          if (noOfPostsShown > listOfPosts!.length) {
            noOfPostsShown = listOfPosts!.length;
          }
        },
      );
    }

    return;
  }

  // Reccomendation Choosing Method
  void selectPostsToShowTheUser() async {
    late final followedUsers;
    try {
      followedUsers = (List.from(widget.currentDatabaseSnapshot
              .child('users')
              .child(currentUserUID)
              .child('following')
              .value as List)
            ..remove('placeHolder'))
          .toSet()
          .toList();
    } catch (e) {
      followedUsers = (List.from((widget.currentDatabaseSnapshot
                  .child('users')
                  .child(currentUserUID)
                  .child('following')
                  .value as Map)
              .values)
            ..remove('placeHolder'))
          .toSet()
          .toList();
    }

    final Map mapOfAllUsers =
        (widget.currentDatabaseSnapshot.child('all users').value as Map);

    mapOfAllUserPosts =
        (widget.currentDatabaseSnapshot.child('all posts').value as Map?);

    // If there Are no posts on the Platform:

    if (mapOfAllUserPosts == null || mapOfAllUserPosts!.isEmpty) {
      if (mounted) {
        setState(() {
          listOfPosts = [];
          mapOfAllUserPosts = {};
        });
      }
      return;
    }

    // Select What Post Exctraction Method To Use

    // In case user is following nobody
    if (followedUsers.isEmpty) {
      await notFilteredRecommendationFunction(
          mapOfAllUserPosts: mapOfAllUserPosts!);
      return;
    }

    // In case User is following every user on the platform
    else if (followedUsers.length == mapOfAllUsers.keys.length) {
      await notFilteredRecommendationFunction(
          mapOfAllUserPosts: mapOfAllUserPosts!);
      return;
    }

    // When the User is a Normal Person
    else {
      await followingSomeUsersRecommendation(
        mapOfAllUserPosts: mapOfAllUserPosts!,
        mapOfAllUsers: mapOfAllUsers,
        followedUsers: followedUsers,
      );
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    selectPostsToShowTheUser();
  }

  @override
  Widget build(BuildContext context) {
    final List listOfPostsToBeShown = (listOfPosts!.toSet().toList());
    return listOfPosts == null || mapOfAllUserPosts == null
        ? const LoadingScreen(loadingText: 'Loading some posts For you')
        : listOfPosts!.isEmpty
            ? const Center(
                child: Card(
                  child: SizedBox(
                    height: 150,
                    width: 250,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Error Occured!",
                            style: TextStyle(fontSize: 18, color: Colors.amber),
                          ),
                          Text(
                            "Please try again later...",
                            style: TextStyle(fontSize: 18, color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: ListView.builder(
                  shrinkWrap: true,
                  itemCount: noOfPostsShown + 1,
                  itemBuilder: (context, index) {
                    if (index == noOfPostsShown) {
                      return const Center(
                        child: Card(
                          child: SizedBox(
                            height: 75,
                            width: 100,
                            child: Center(
                              child: Text("Load More"),
                            ),
                          ),
                        ),
                      );
                    }

                    return PostBlock(
                      currentDatabaseSnapshot: widget.currentDatabaseSnapshot,
                      postData: widget.currentDatabaseSnapshot
                          .child('users')
                          .child(
                              mapOfAllUserPosts![listOfPostsToBeShown[index]])
                          .child('posts')
                          .child(listOfPostsToBeShown[index]),
                    );
                  },
                ),
              );
  }
}
