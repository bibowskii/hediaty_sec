import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:iconsax/iconsax.dart';

class friendCard extends StatelessWidget {
  final User myUser;
  const friendCard({super.key, required this.myUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100,
      //height: 100,
      child: Column(
        children: [
          const CircleAvatar(
            child: Icon(Iconsax.user),
          ),
          Text(myUser.name!),
        ],
      ),
    );
  }
}
