import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_Profile.dart';
import 'package:hediaty_sec/screens/notifications_screen/notifications_controller.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> followers = [];
  List<dynamic> pledgers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final controller = NotificationsController.instance;
      final fetchedFollowers = await controller.getNotifications();
      final fetchedPledgers = await controller.getPledgers();

      setState(() {
        followers = fetchedFollowers;
        pledgers = fetchedPledgers;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Failed to load notifications: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onRefresh() async {
    setState(() => isLoading = true);
    await _loadNotifications();
  }

  Widget _buildList({
    required String title,
    required List<dynamic> items,
    required bool isFollower,
  }) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            'No New $title',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'New $title',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final profileImage = item.imageURL?.isNotEmpty == true
                ? ImageConverterr().stringToImage(item.imageURL!)
                : null;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: profileImage != null
                    ? MemoryImage(profileImage)
                    : const AssetImage('lib/assets/icons/favicon.png')
                as ImageProvider,
                radius: 30,
              ),
              title: Text(
                isFollower
                    ? '${item.name ?? "Someone"} just followed you!'
                    : '${item.name ?? "Someone"} just pledged your gift!',
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: isFollower
                  ? const Text('Check out their profile')
                  : null,
              onTap: isFollower
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FriendDetailScreen(friend: item),
                  ),
                );
              }
                  : null,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<theme>().dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      backgroundColor: isDarkMode
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                _buildList(
                  title: 'Followers',
                  items: followers,
                  isFollower: true,
                ),
                _buildList(
                  title: 'Pledges',
                  items: pledgers,
                  isFollower: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
