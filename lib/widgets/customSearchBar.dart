import 'package:flutter/material.dart';
import 'package:hediaty_sec/screens/HomePage/homePage_controller.dart';
import 'package:hediaty_sec/screens/friend_profile/friend_Profile.dart';

import '../models/data/users.dart';

class customSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function onEmptyQuery;
  const customSearchBar({super.key, required this.searchController, required this.onEmptyQuery});

  @override
  State<customSearchBar> createState() => _customSearchBarState();
}

class _customSearchBarState extends State<customSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: const Color(0XFF000000),
      borderRadius: BorderRadius.circular(20.0),
      child: TextField(
        onSubmitted: (String query) async {
          if (query.isEmpty) {
            setState(() {
              widget.onEmptyQuery();
            });

            return;
          }

          User? myUser = await HomePageController().getFriendsList(query);

          if (myUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendDetailScreen(friend: myUser),
              ),
            );
          } else {
            setState(() {
              widget.onEmptyQuery();
            });
          }
        },

        controller: widget.searchController ,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Search by phone number...',
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
              ),
              Container(
                height: 24,
                width: 2,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
            ],
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          // Logic for searching to be implemented
        },
      ),
    );
  }
}
