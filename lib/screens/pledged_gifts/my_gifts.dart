import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/widgets/gift_card.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details.dart';
import 'package:hediaty_sec/screens/pledged_gifts/my_gifts_controller.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';

class myGifts extends StatefulWidget {
  const myGifts({super.key});

  @override
  State<myGifts> createState() => _myGiftsState();

}

class _myGiftsState extends State<myGifts> {
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
    await MyGiftsScreenController.instance.GetMyPledgedGifts(UserManager().getUserId()!);
    setState(() {});
  }

  Widget build(BuildContext context) {
     return RefreshIndicator(
      onRefresh: _fetchGifts,
      child: Scaffold(
        backgroundColor: context.watch<theme>().dark
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.extraLightBackgroundGray,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            //temp till is pledged and images are done
            children: MyGiftsScreenController.instance.myGifts
                .map(
                  (gift) => GestureDetector(
                child: GiftCard(
                  name: gift.name, PledgedBy: gift.pledgedBy, Status: gift.status, id: gift.id,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GiftDetails(myGift: gift,),
                    ),
                  );
                },
              ),
            )
                .toList(),
          ),
        ),

      ),
    );
  }
}
