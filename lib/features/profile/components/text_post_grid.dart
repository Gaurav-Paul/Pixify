import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/home/components/post_block.dart';
import 'package:pixify/services/database_service.dart';

class TextPostGrid extends StatefulWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  const TextPostGrid({
    super.key,
    required this.currentDatabaseSnapshot,
    required this.userID,
  });

  @override
  State<TextPostGrid> createState() => _TextPostGridState();
}

class _TextPostGridState extends State<TextPostGrid> {
  late List listOfTextPosts;
  bool loading = true;

  getTextPosts() async {
    listOfTextPosts = ((await DatabaseService.database
                    .ref(null)
                    .child('users')
                    .child(widget.userID)
                    .child('posts')
                    .get())
                .children
                .length !=
            1
        ? (((await DatabaseService.database
                    .ref(null)
                    .child('users')
                    .child(widget.userID)
                    .child('posts')
                    .get())
                .children)
            // .values
            .toList()
          ..removeWhere((data) =>
              data.value == 'placeHolder' ||
              data.child('type').value != 'text'))
        : []);

    if (mounted) {
      setState(() {
        listOfTextPosts = listOfTextPosts;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getTextPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
        : listOfTextPosts.isEmpty
            ? const Center(child: Text("No Shared Thoughts.."))
            : ListView.builder(
                itemCount: listOfTextPosts.length,
                itemBuilder: (context, index) {
                  return PostBlock(
                      isOwner: true,
                      postData: listOfTextPosts[index],
                      currentDatabaseSnapshot: widget.currentDatabaseSnapshot);
                },
              );
  }
}
