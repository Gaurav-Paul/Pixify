import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/add%20post/tabs/image_only_tab.dart';
import 'package:pixify/features/add%20post/tabs/text_only_tab.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          dragStartBehavior: DragStartBehavior.down,
          controller: tabController,
          children: [
            TextOnlyTab(),
            const ImageOnlyTab(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
          child: TabBar(
            dividerHeight: 0,
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            splashFactory: NoSplash.splashFactory,
            controller: tabController,
            tabs: const [
              Text("Text"),
              Text("Image"),
            ],
          ),
        ),
      ),
    );
  }
}
