import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/profile/components/profile_pic_circle.dart';
import 'package:pixify/services/database_service.dart';

class ImagePostGrid extends StatefulWidget {
  final DataSnapshot currentDatabaseSnapshot;
  final String userID;
  const ImagePostGrid({
    super.key,
    required this.currentDatabaseSnapshot,
    required this.userID,
  });

  @override
  State<ImagePostGrid> createState() => _ImagePostGridState();
}

class _ImagePostGridState extends State<ImagePostGrid> {
  late List listOfImagePosts;
  bool loading = true;

   getImagePosts() async {
    listOfImagePosts = ((await DatabaseService.database
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
              data.child('type').value != 'image'))
        : []);

    if (mounted) {
      setState(() {
        listOfImagePosts = listOfImagePosts;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getImagePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
        : listOfImagePosts.isEmpty
            ? const Center(
                child: Text("No Pics Shared"),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: listOfImagePosts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.white24,
                          pageBuilder: (context, _, __) => GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            onVerticalDragStart: (_) =>
                                Navigator.of(context).pop(),
                            child: Center(
                              child: Card(
                                child: SizedBox(
                                  height: 450,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: ProfilePicCircle(
                                            profilePicURL: widget
                                                .currentDatabaseSnapshot
                                                .child('users')
                                                .child(widget.userID)
                                                .child('profilePicURL')
                                                .value
                                                .toString(),
                                          ),
                                          title: Text(widget
                                              .currentDatabaseSnapshot
                                              .child('users')
                                              .child(widget.userID)
                                              .child('username')
                                              .value
                                              .toString()),
                                        ),
                                        const SizedBox(height: 10),
                                        Card(
                                          clipBehavior: Clip.hardEdge,
                                          child: SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: Image.network(
                                              fit: BoxFit.contain,
                                              listOfImagePosts[index]
                                                  .child('imageURL')
                                                  .value
                                                  .toString(),
                                              loadingBuilder: (context, child,
                                                      loadingProgress) =>
                                                  loadingProgress != null
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!,
                                                            color: Colors.amber,
                                                          ),
                                                        )
                                                      : child,
                                            ),
                                          ),
                                        ),
                                        listOfImagePosts[index]
                                                        .child('type')
                                                        .value
                                                        .toString() ==
                                                    'image' &&
                                                listOfImagePosts[index]
                                                    .child('text')
                                                    .value
                                                    .toString()
                                                    .isNotEmpty
                                            ? const SizedBox(height: 15)
                                            : const SizedBox(),
                                        listOfImagePosts[index]
                                                        .child('type')
                                                        .value
                                                        .toString() ==
                                                    'image' &&
                                                listOfImagePosts[index]
                                                    .child('text')
                                                    .value
                                                    .toString()
                                                    .isNotEmpty
                                            ? Text(listOfImagePosts[index]
                                                .child('text')
                                                .value
                                                .toString())
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Image.network(
                            listOfImagePosts[index]
                                .child('imageURL')
                                .value
                                .toString(),
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress != null
                                    ? CircularProgressIndicator(
                                        value: loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!,
                                      )
                                    : child,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black45,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
