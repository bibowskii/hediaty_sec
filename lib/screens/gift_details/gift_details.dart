import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/screens/update_gift/edit_gift_screen.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details_controller.dart';
import 'package:hediaty_sec/screens/gift_details/pledge_button.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/services/user_manager.dart';

import '../../models/data/Gifts.dart';

class GiftDetails extends StatefulWidget {
  final Gift myGift;
  final String? eventName;

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

  @override
  Widget build(BuildContext context) {
    var giftImage;
    if (widget.myGift.imgURl != null && widget.myGift.imgURl != '') {
      giftImage = ImageConverterr().stringToImage(widget.myGift.imgURl!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          widget.myGift.userID == UserManager().getUserId()
              ? IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>EditGift(EventID: widget.myGift.eventID, myGift:widget.myGift)));
            },
            icon: Icon(Icons.edit),
          )
              : Icon(CupertinoIcons.gift),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //color: CupertinoColors.activeBlue, was just used as a placeholder at first
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Hero(
                  tag: widget.myGift.id,
                  child: giftImage != null
                      ? Image.memory(giftImage)
                      : Image.asset('lib/assets/icons/logo.png'),
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.myGift.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.myGift.description ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Category: ${widget.myGift.category ?? 'No category'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("Status: "),
                  widget.myGift.pledgedBy != ''
                      ? widget.myGift.status != false || widget.myGift.status !=''
                      ? CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5
                  )
                      : CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 5
                  )
                      : CircleAvatar(
                      backgroundColor: CupertinoColors.inactiveGray,
                      radius: 5
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Price: \$${widget.myGift.price}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (widget.eventName != null)
                Text(
                  'Event name: ${widget.eventName}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 16),
              Center(
                child: widget.myGift.userID == UserManager().getUserId() ? Container() :PledgeButton(myGift: widget.myGift),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
