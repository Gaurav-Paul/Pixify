import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/features/home/home_page.dart';
import 'package:pixify/features/loading/loading_screen.dart';
import 'package:pixify/features/messaging/messages_page.dart';
import 'package:pixify/features/profile/profile_page.dart';
import 'package:pixify/features/search/search_page.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:provider/provider.dart';

class ContentWrapper extends StatefulWidget {
  final int? page;
  const ContentWrapper({
    super.key,
    this.page,
  });

  @override
  State<ContentWrapper> createState() => _ContentWrapperState();
}

class _ContentWrapperState extends State<ContentWrapper> {
  int navBarIndex = 0;
  Widget? pageShown;
  late final Timer timer;
  DataSnapshot? cds;

  asyncInitStuff() async {
    if (mounted) {
      cds = await DatabaseService.database.ref(null).get();
      setState(() {
        cds = cds;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().updateUserPresence();
    timer = Timer(const Duration(minutes: 1), () {});
    asyncInitStuff();
    if (widget.page != null && widget.page == 2) {
      navBarIndex = 1;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseEvent? currentDatabaseState = Provider.of<DatabaseEvent?>(context);
    return currentDatabaseState == null
        ? const LoadingScreen(loadingText: 'Accessing the Database')
        : Scaffold(
            body: navBarIndex == 0
                ? StreamProvider.value(
                    value: DatabaseService.getEntireDatabaseStream(),
                    initialData: currentDatabaseState,
                    child: HomePage(
                        currentDatabaseSnapshot: currentDatabaseState.snapshot),
                  )
                : 
                navBarIndex == 1 ? MessagesPage(currentDatabaseSnapshot: currentDatabaseState.snapshot) :
                pageShown,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navBarIndex,
              elevation: 2,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              indicatorColor: Colors.amber,
              onDestinationSelected: (value) {
                if (mounted) {
                  setState(() {
                    navBarIndex = value;
                    if (value == 0) {
                      pageShown = StreamProvider.value(
                        value: DatabaseService.getEntireDatabaseStream(),
                        initialData: currentDatabaseState,
                        child: HomePage(
                            currentDatabaseSnapshot:
                                currentDatabaseState.snapshot),
                      );
                    } else if (value == 1) {
                      pageShown = MessagesPage(
                        currentDatabaseSnapshot: currentDatabaseState.snapshot,
                      );
                    } else if (value == 2) {
                      pageShown = SearchPage(
                        userID: AuthService.auth.currentUser!.uid,
                      );
                    } else if (value == 3) {
                      pageShown = ProfilePage(
                        currentDatabaseSnapshot: currentDatabaseState.snapshot,
                        userID: AuthService.auth.currentUser!.uid,
                      );
                    }
                  });
                }
              },
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.home,
                    color: Colors.black87,
                  ),
                  icon: Icon(Icons.home_outlined),
                  label: "Home",
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.message,
                    color: Colors.black87,
                  ),
                  icon: Icon(Icons.message_outlined),
                  label: "Message",
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.account_circle,
                    color: Colors.black87,
                  ),
                  icon: Icon(Icons.account_circle_outlined),
                  label: "Account",
                ),
              ],
            ),
          );
  }
}
