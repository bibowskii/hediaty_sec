import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details_controller.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';


class PledgeButton extends StatefulWidget {
  final Gift myGift;

  PledgeButton({required this.myGift});

  @override
  _PledgeButtonState createState() => _PledgeButtonState();
}

class _PledgeButtonState extends State<PledgeButton> {
  late bool isPledged;
  late bool isPledgedByUser;

  @override
  void initState() {
    super.initState();

    isPledged = GiftDetailsController.instance.isPledged;
    isPledgedByUser = GiftDetailsController.instance.isPledgedByUser;
  }


  void updatePledgeState() {
    setState(() {
      isPledged = GiftDetailsController.instance.isPledged;
      isPledgedByUser = GiftDetailsController.instance.isPledgedByUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final userId = UserManager().getUserId();

        if (userId != null) {
          widget.myGift.pledgedBy = userId;

          try {

            final giftMethod = GiftDetailsController.instance.isPledged
                ? giftMethods().unpledge  // Unpledge if already pledged
                : giftMethods().pledge;   // Pledge if not pledged


            await giftMethod(widget.myGift);
            GiftDetailsController.instance.isPledged = !GiftDetailsController.instance.isPledged;
            GiftDetailsController.instance.isPledgedByUser = GiftDetailsController.instance.isPledgedByUser ? false : true;


            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pledge action was successful!')),
            );

            updatePledgeState();
          } catch (e) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to perform pledge action: ${e.toString()}')),
            );
          }
        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not logged in.')),
          );
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 300,
        height: 75,
        decoration: BoxDecoration(
          color: isPledged
              ? isPledgedByUser
              ? CupertinoColors.activeBlue
              : CupertinoColors.activeGreen
              : CupertinoColors.inactiveGray,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.5),
             /* blurRadius: 4,
              spreadRadius: 2,*/
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          isPledged
              ? isPledgedByUser
              ? 'Pledged by you'
              : 'Pledged by Someone Else'
              : 'Pledge',
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
