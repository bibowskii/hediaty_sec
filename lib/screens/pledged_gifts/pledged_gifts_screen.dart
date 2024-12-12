import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/widgets/gift_card.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details.dart';
import 'package:hediaty_sec/screens/pledged_gifts/pledgd_gifts_screen_controller.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:hediaty_sec/models/data/users.dart';

class PledgedGiftsScreen extends StatefulWidget {
  const PledgedGiftsScreen({super.key});

  @override
  State<PledgedGiftsScreen> createState() => _PledgedGiftsScreenState();
}

class _PledgedGiftsScreenState extends State<PledgedGiftsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
   /* var user = await userMethods().getUserByID(UserManager().getUserId()!);
    User myUser = User.fromMap(user!);*/
    await PledgdGiftsScreenController.instance.GetMyPledgedGifts(UserManager().getUserId()!);
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
            children: PledgdGiftsScreenController.instance.pledgedGifts
                .map(
                  (gift) => GestureDetector(
                child: GiftCard(
                    name: gift.name, PledgedBy: gift.pledgedBy),
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
