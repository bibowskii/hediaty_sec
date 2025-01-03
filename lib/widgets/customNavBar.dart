import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/is_logged_in_provider.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/HomePage/homePage.dart';
import 'package:hediaty_sec/screens/event_list/event_list_screen.dart';
import 'package:hediaty_sec/screens/friends_list/friends_list_screen.dart';
import 'package:hediaty_sec/screens/notifications_screen/notifications_screen.dart';
import 'package:hediaty_sec/screens/pledged_gifts/tab_bar.dart';
import 'package:hediaty_sec/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/user_manager.dart';

class CustomNavBar extends StatefulWidget {
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {

  int _selectedIndex = 2;


  final List<Widget> _screens = [
    EventListScreen(),
    FriendsListScreen(),
    Homepage(),
    GiftTabBarScreen(),
    profileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.watch<theme>().dark ? Colors.black : Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            UserManager().clearUser();
            authService().signOut();
            context.read<AccessTokenProvider>().clearAccessToken();
          },
        ),
        title: const Text(
          'Hediaty',
          style: TextStyle(
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black54,
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
          }, icon: Icon(Icons.notifications)),
          IconButton(
            icon: Icon(context.watch<theme>().dark
                ? Icons.wb_sunny
                : Icons.nightlight_round),
            onPressed: () {
              context.read<theme>().changeTheme();
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.event, size: 30, color: Colors.black),
          Icon(Icons.people, size: 30, color: Colors.black),
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.card_giftcard, size: 30, color: Colors.black),
          Icon(Icons.account_circle, size: 30, color: Colors.black),
        ],
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        backgroundColor: context.watch<theme>().dark
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.extraLightBackgroundGray,
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
