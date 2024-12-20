import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_screen.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_profile_controller.dart';
import 'package:hediaty_sec/services/FCM_services.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/services/unused/one_signal_service.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';

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

    var profileImage;
    if(widget.friend.imageURL != '') {
      profileImage = ImageConverterr().stringToImage(widget.friend.imageURL!);
    }

    return Scaffold(
      backgroundColor:
          context.watch<theme>().dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            context.watch<theme>().dark ? Colors.black : Colors.white,
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
                        Hero(
                          tag: widget.friend.id,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:profileImage!=null? MemoryImage(profileImage): AssetImage('lib/assets/icons/favicon.png'),
                            radius: 70,
                          ),
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
                widget.friend.id != UserManager().getUserId() ? GestureDetector(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      decoration: BoxDecoration(
                        color: FriendProfileController.instance.isFriend? Colors.blue: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color:FriendProfileController.instance.isFriend? Colors.white: Colors.blue, width: 2.0),
                      ),
                      width: 75,
                      height: 35,
                      child: Center(
                        child: Text(
                          FriendProfileController.instance.isFriend ? 'Following' : 'Follow',
                          style: TextStyle(color:FriendProfileController.instance.isFriend? Colors.white: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    Friend myFriend = Friend(
                      UserManager().getUserId()!,
                      widget.friend.id,
                    );


                    bool success;
                    if (FriendProfileController.instance.isFriend) {
                      success = await Follow().removeFriend(myFriend);
                      FcmServices().sendFCMMessage('you lost a follower', 'someone just unfollowed you, go buy them a Gift and Say sorry', widget.friend.id);
                    } else {
                      success = await Follow().followFriend(myFriend);
                      FcmServices().sendFCMMessage('A new Follower', 'Someone Just Followed you!', widget.friend.id);
                    }

                    if (success) {
                      setState(() {
                        FriendProfileController.instance.isFriend =
                        !FriendProfileController.instance.isFriend;

                      });
                    } else {

                      print("Failed to update friendship status");
                    }
                  },
                ):SizedBox(),

              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 220,
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
