import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/search/components/custom_search_bar.dart';
import 'package:pixify/features/search/components/search_user_tile.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';

class SearchPage extends StatefulWidget {
  final String userID;
  const SearchPage({
    super.key,
    required this.userID,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  Future<List<Widget>> showAllUsers() async {
    DataSnapshot currentDatabaseSnapshot =
        await DatabaseService.database.ref('').get();

    var listOfAllResultUsers =
        ((currentDatabaseSnapshot.child('all users').value as Map)
              ..removeWhere(
                  (key, value) => key == AuthService.auth.currentUser!.uid))
            .keys;

    late final List listOfFollowedUsers;

    try {
      listOfFollowedUsers = (currentDatabaseSnapshot
          .child('users')
          .child(widget.userID)
          .child('following')
          .value as List);
    } catch (e) {listOfFollowedUsers = (currentDatabaseSnapshot
            .child('users')
            .child(widget.userID)
            .child('following')
            .value as Map)
        .values
        .toList();}
    

    return List.generate(
      listOfAllResultUsers.length,
      (index) => SearchUserTile(
        currentDatabaseSnapshot: currentDatabaseSnapshot,
        userID: listOfAllResultUsers.toList()[index],
        listOfFollowedUsers: listOfFollowedUsers,
      ),
      growable: true,
    );
  }

  Future<List<Widget>> showFilteredResult({required String input}) async {
    DataSnapshot currentDatabaseSnapshot =
        await DatabaseService.database.ref('').get();
    List listOfAllResultUsers =
        ((currentDatabaseSnapshot.child('all users').value as Map)
              ..removeWhere(
                (key, value) =>
                    key == AuthService.auth.currentUser!.uid ||
                    !(value.contains(input)),
              ))
            .keys
            .toList()
          ..sort();

    final List listOfFollowedUsers = (currentDatabaseSnapshot
        .child('users')
        .child(widget.userID)
        .child('following')
        .value as List);

    print(listOfAllResultUsers);

    if (listOfAllResultUsers.isEmpty) {
      return const [
        ListTile(
          title: Text("No Users with that username"),
        )
      ];
    }

    return List.generate(
      listOfAllResultUsers.length,
      (index) => SearchUserTile(
        currentDatabaseSnapshot: currentDatabaseSnapshot,
        userID: listOfAllResultUsers.toList()[index],
        listOfFollowedUsers: listOfFollowedUsers,
      ),
      growable: true,
    );
  }

  List<Widget> searchResultsList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    showAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                CustomSearchBar(
                  controller: searchController,
                  onTapFunction: () async {
                    if (searchController.text.isEmpty) {
                      var temp = await showAllUsers();
                      if (mounted) {
                        setState(() {
                          searchResultsList = temp;
                        });
                      }
                    }
                  },
                  onChangedFunction: (val) async {
                    if (searchController.text.isEmpty) {
                      var temp = await showAllUsers();
                      if (mounted) {
                        setState(() {
                          searchResultsList = temp;
                        });
                      }
                    }
                    if (searchController.text.isNotEmpty) {
                      var temp = await showFilteredResult(
                          input: searchController.text);
                      if (mounted) {
                        setState(() {
                          searchResultsList = temp;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: searchResultsList,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
