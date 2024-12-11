//far from done, needs ui
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../models/data/Gifts.dart';

class GiftDetails extends StatelessWidget {
  Gift myGift;
  String? eventName;
  GiftDetails({super.key, required this.myGift,  this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.watch<theme>().dark ? Colors.black : Colors.white,
        title: Text(myGift.name),
      ),
      body: Column(
        children: [
          Container(
            color: CupertinoColors.activeBlue,
            width: double.infinity,
            height: MediaQuery.of(context).size.height *0.3,
            child: Center(child: Text('place holder for images')),

          ),
          SizedBox(height: 16,),
          Text(myGift.description),
          Text(myGift.category),
          myGift.pledgedBy != null? Text(myGift.pledgedBy!): Text('Not pledged yet'),
          Text(myGift.price.toString()),

          eventName!= null? Text('event name: ${eventName}'): Text('') ,

        ],
      ),
    );
  }
}
