import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_Profile.dart';
import 'package:hediaty_sec/screens/notifications_screen/notifications_controller.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var Followers;
  var pledgers;
  bool isLoading = true;
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
    Followers = await NotificationsController().getNotifications();
    pledgers = await NotificationsController().getPledgers();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    Followers.clear();
    setState(() {
      isLoading = true;
    });
    await _initAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor:
            context.watch<theme>().dark ? Colors.black : Colors.white,
      ),
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Followers.isEmpty
              ? Center(child: Text('No New Followers'))
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Column(
                    children: [
                      Text(
                        'New Followers',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        itemCount: Followers.length,
                        itemBuilder: (context, index) {
                          final friend = Followers[index];
                          var profileImage;
                          if (friend.imageURL != '') {
                            profileImage = ImageConverterr()
                                .stringToImage(friend.imageURL!);
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: profileImage != null
                                  ? MemoryImage(profileImage)
                                  : AssetImage('lib/assets/icons/favicon.png'),
                              radius: 40,
                            ),
                            title: Text('${friend.name!} Just followed you!'),
                            subtitle: const Text('Check their profile out'),
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
                      Text(
                        'New Pledges',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        itemCount: pledgers.length,
                        itemBuilder: (context, index) {
                          final pledger = pledgers[index];
                          var profileImage;
                          if (pledger.imageURL != '') {
                            profileImage = ImageConverterr()
                                .stringToImage(pledger.imageURL!);
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: profileImage != null
                                  ? MemoryImage(profileImage)
                                  : AssetImage('lib/assets/icons/favicon.png'),
                              radius: 40,
                            ),
                            title:
                                Text('${pledger.name!} Just pledged your Gift'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
