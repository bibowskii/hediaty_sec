import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class cusNavBar extends StatelessWidget {
  const cusNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CurvedNavigationBar(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        //buttonBackgroundColor: CupertinoColors.extraLightBackgroundGray,
        items: const <Widget>[
          Icon(Iconsax.home, size: 30),
          Icon(Iconsax.gift, size: 30),
          Icon(Icons.contact_phone, size: 30),
          Icon(Icons.event, size: 30),
          Icon(Iconsax.profile_2user, size: 30,color: Colors.black,),


        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }
}
