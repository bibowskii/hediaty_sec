//far from done, needs ui
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details_controller.dart';
import 'package:hediaty_sec/screens/gift_details/pledge_button.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';

import '../../models/data/Gifts.dart';

class GiftDetails extends StatefulWidget {
  Gift myGift;
  String? eventName;
  GiftDetails({super.key, required this.myGift, this.eventName});

  @override
  State<GiftDetails> createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetails> {
  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  Future<void> _initCheck() async {
    await GiftDetailsController.instance.checkIfPledged(widget.myGift);
    await GiftDetailsController.instance.checkIfPledgedByUser(widget.myGift);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: CupertinoColors.activeBlue,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(child: Text('place holder for images')),
          ),
          SizedBox(
            height: 16,
          ),
          Text(widget.myGift.name),
          Text(widget.myGift.description),
          Text(widget.myGift.category),
          widget.myGift.pledgedBy != null
              ? Text(widget.myGift.pledgedBy!)
              : Text('Not pledged yet'),
          Text(widget.myGift.price.toString()),
          widget.eventName != null
              ? Text('event name: ${widget.eventName}')
              : Text(''),
          Spacer(),
          Center(
            child:PledgeButton(myGift: widget.myGift,) ,
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
