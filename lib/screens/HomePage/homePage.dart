import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/HomePage/widgets/friendCard.dart';
import 'package:hediaty_sec/screens/add_event/add_event_screen.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_Profile.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/customSearchBar.dart';
import 'package:provider/provider.dart';

import 'homePage_controller.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  HomePageController _controller = HomePageController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initAsync() async {
    var userID = await UserManager().getUserId();
    var userMap = await userMethods().getUserByID(userID!);
    var user = User.fromMap(userMap!);
    if (user != null) {
      await _controller.filterThisMonth(user);
      await _controller.filterFriends();
      setState(() {});
    } else {
      print("User is null");
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _controller.monthEvents.clear();
      _controller.nextYearEvents.clear();
      _controller.yearEvents.clear();
      _controller.yearEventsFriends.clear();
      _controller.monthEventsFriends.clear();
      _controller.nextYearEventsFriends.clear();
      _controller.friendsThisMonth.clear();
      _controller.friendsThisYear.clear();
      _controller.friendsLater.clear();
    });
    await _initAsync();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  customSearchBar(
                    searchController: searchController,
                    onEmptyQuery: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('No matches for that number were found'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text('Upcoming Events this Month'),
                  const SizedBox(
                    height: 10,
                  ),
                  _controller.friendsThisMonth.isEmpty
                      ? const Center(child: Text('No events this month'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _controller.friendsThisMonth
                                .map(
                                  (User user) => GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: friendCard(myUser: user, ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FriendDetailScreen(friend: user),
                                        ),
                                      );
                                    },
                                  ),
                                )
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
                  _controller.friendsThisYear.isEmpty
                      ? const Center(child: Text('No events this year'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _controller.friendsThisYear
                                .map((User user) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
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
                  _controller.friendsLater.isEmpty
                      ? const Center(child: Text('No upcoming events'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _controller.friendsLater
                                .map((User user) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addEventScreen()),
          ).then((value){setState(() {

          });});
        },
        backgroundColor: Colors.blueAccent,
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
        ),
      ),
    );
  }
}
