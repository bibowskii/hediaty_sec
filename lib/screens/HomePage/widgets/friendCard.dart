import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:iconsax/iconsax.dart';

class friendCard extends StatelessWidget {
  final User myUser;

  const friendCard({super.key, required this.myUser,});

  @override
  Widget build(BuildContext context) {
    var profileImage;
    if(myUser.imageURL != '') {
      profileImage = ImageConverterr().stringToImage(myUser.imageURL!);
    }
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage:profileImage!=null? MemoryImage(profileImage): AssetImage('lib/assets/icons/favicon.png'),
            radius: 70,
          ),
          Text(myUser.name!),
        ],
      ),
    );
  }
}
