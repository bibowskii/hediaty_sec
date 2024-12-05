import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/HomePage/widgets/friendCard.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/customSearchBar.dart';
import 'package:provider/provider.dart';
import 'homePage_controller.dart';
import 'package:hediaty_sec/models/data/users.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    // You can call these functions here
    filterThisMonth(UserManager().getUser()!); // Make sure `myUser` is defined
    filterFriends();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const customSearchBar(),
                const SizedBox(
                  height: 40,
                ),
                const Text('Upcoming Events this Month'),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: friendsThisMonth
                        .map((User user) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: friendCard(myUser: user),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Upcoming Events this Year'),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: friendsThisYear
                        .map((User user) => Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: friendCard(myUser: user),
                    ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('No Events'),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: friendsLater
                        .map((User user) => Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: friendCard(myUser: user),
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.lightGreenAccent,
          tooltip: 'Add Event',
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: 15,
                color: Colors.black,
              ),
              Icon(
                Icons.event_outlined,
                color: Colors.black,
                size: 30,
              ),
            ],
          )),
      //bottomNavigationBar: cusNavBar(),
    );
  }
}
