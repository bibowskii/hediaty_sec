import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_screen.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_profile_controller.dart';
import '../../models/data/friends.dart';


class FriendDetailScreen extends StatefulWidget {
  final User friend;

  FriendDetailScreen({required this.friend});

  @override
  State<FriendDetailScreen> createState() => _FriendDetailScreenState();
}

class _FriendDetailScreenState extends State<FriendDetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

//checks if u are friends and fetches events
  Future<void> _fetch() async {
    await FriendProfileController.instance.getEvents(widget.friend);
    await FriendProfileController.instance
        .checkFriend(UserManager().getUserId()!, widget.friend.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final events = FriendProfileController.instance.friendEvents;

    final nameStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final infoStyle = TextStyle(fontSize: 16, color: Colors.grey[700]);

    return Scaffold(
      backgroundColor:
          context.watch<theme>().dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            context.watch<theme>().dark ? Colors.black : Colors.white,
        title: Text(widget.friend.name!),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.watch<theme>().dark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                          radius: 50,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              widget.friend.name!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(widget.friend.email!,
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 4,
                            ),
                            Text(widget.friend.number!,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.blue, width: 2.0),
                    ),
                    width: 75,
                    height: 35,
                    child: Center(
                      child: Text(
                        FriendProfileController.instance.isFriend ? 'Following' : 'Follow',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  onTap: () async {
                    Friend myFriend = Friend(
                      UserManager().getUserId()!,
                      widget.friend.id,
                    );

                    // Perform the asynchronous operation
                    bool success;
                    if (FriendProfileController.instance.isFriend) {
                      success = await Follow().removeFriend(myFriend);
                    } else {
                      success = await Follow().followFriend(myFriend);
                    }

                    // Update the state synchronously
                    if (success) {
                      setState(() {
                        FriendProfileController.instance.isFriend =
                        !FriendProfileController.instance.isFriend;
                      });
                    } else {
                      // Handle failure (optional)
                      print("Failed to update friendship status");
                    }
                  },
                ),

              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 200,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: context.watch<theme>().dark
                    ? CupertinoColors.darkBackgroundGray
                    : CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: events.isNotEmpty
                  ? ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.event),
                          ),
                          title: Text(event.name),
                          subtitle: Text(event.date.toString()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailsScreen(event: event),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(child: Text("No events available.")),
            ),
          )
        ],
      ),
    );
  }
}
