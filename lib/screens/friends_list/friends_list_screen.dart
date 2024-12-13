import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_Profile.dart';
import 'package:hediaty_sec/screens/friends_list/friends_list_controller.dart';
import 'package:provider/provider.dart';

import '../../services/image_to_stringVV.dart';

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    await FriendsListController.instance.getFriendsList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    await _fetchFriends();
  }

  @override
  Widget build(BuildContext context) {
    final friends = FriendsListController.instance.friendsList;

    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : friends.isEmpty
              ? Center(child: Text('No friends found'))
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      var profileImage;
                      if(friend.imageURL != null) {
                        profileImage = ImageConverterr().stringToImage(friend.imageURL!);
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:profileImage!=null? MemoryImage(profileImage): AssetImage('lib/assets/icons/favicon.png'),
                          radius: 30,
                        ),
                        title: Text(friend.name!),
                        subtitle: Text(friend.number!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FriendDetailScreen(friend: friend),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
