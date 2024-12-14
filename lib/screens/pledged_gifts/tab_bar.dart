import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'my_gifts.dart';
import 'pledged_gifts_screen.dart';

class GiftTabBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.watch<theme>().dark ? Colors.black : Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.card_giftcard), text: 'My Gifts'),
              Tab(icon: Icon(Icons.volunteer_activism), text: 'Pledged Gifts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            myGifts(),
            PledgedGiftsScreen(),
          ],
        ),
      ),
    );
  }
}