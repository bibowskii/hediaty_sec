import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/is_logged_in_provider.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/HomePage/homePage.dart';
import 'package:hediaty_sec/screens/event_list/event_list_screen.dart';
import 'package:hediaty_sec/screens/friends_list/friends_list_screen.dart';
import 'package:hediaty_sec/screens/pledged_gifts/pledged_gifts_screen.dart';
import 'package:hediaty_sec/screens/profile/profile_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class CustomNavBar extends StatefulWidget {
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  // Initial selected index
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    Homepage(),
    EventListScreen(),
    FriendsListScreen(),
    PledgedGiftsScreen(),
    profileScreen(), // Corrected here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            context.watch<theme>().dark ? Colors.black : Colors.white,
        //backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authService().signOut();
            context.read<isLogged>().changeState();
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
          IconButton(
            icon: Icon(context.watch<theme>().dark
                ? Icons.wb_sunny
                : Icons.nightlight_round),
            onPressed: () {
              context.read<theme>().changeTheme();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Iconsax.profile_add),
          ),
          const SizedBox(width: 6,)
        ],
      ),
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.event,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.people,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.card_giftcard,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.black,
          ),
        ],
        color: Colors.lightGreenAccent,
        buttonBackgroundColor: Colors.white,
        backgroundColor: context.watch<theme>().dark
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.extraLightBackgroundGray,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
