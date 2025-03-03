import 'package:flutter/material.dart';
import 'package:pixify/features/add%20post/tabs/image_only_tab.dart';
import 'package:pixify/features/add%20post/tabs/image_with_caption.dart';
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
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          children: [
            TextOnlyTab(),
            const ImageOnlyTab(),
            const ImageWithCaption(),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabPageSelector(
              indicatorSize: 15,
              color: Colors.black,
              selectedColor: Colors.amber,
              controller: tabController,
            ),
          ],
        ),
      ),
    );
  }
}
