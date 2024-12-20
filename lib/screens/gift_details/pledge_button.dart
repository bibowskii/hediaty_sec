import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/models/repository/User_fcm_methods.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details_controller.dart';
import 'package:hediaty_sec/services/FCM_services.dart';
import 'package:hediaty_sec/services/unused/FCM_class.dart';
import 'package:hediaty_sec/services/user_manager.dart';

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
    // Initialize pledge state from the GiftDetailsController instance
    isPledged = GiftDetailsController.instance.isPledged;
    isPledgedByUser = GiftDetailsController.instance.isPledgedByUser;
  }

  // Optimized pledge/unpledge action
  void pledgeAction() async {
    final userId = UserManager().getUserId();
    if (userId == null) {
      // Show error if the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    widget.myGift.pledgedBy = userId;

    try {
      // Determine if the action is to pledge or unpledge
      bool newPledgeStatus = !isPledged;
      bool newPledgeByUserStatus = !isPledgedByUser;

      // Perform the pledge/unpledge action
      await (newPledgeStatus ? giftMethods().pledge : giftMethods().unpledge)(widget.myGift);

      // Update the state of the pledge
      GiftDetailsController.instance.isPledged = newPledgeStatus;
      GiftDetailsController.instance.isPledgedByUser = newPledgeByUserStatus;

      // Send appropriate FCM message
      if (newPledgeStatus) {
        FcmServices().sendFCMMessage('A new Pledge!!', 'Someone Just Pledged you gift', widget.myGift.userID );
        String? fcmToken = await UserFcmMethods().getUserFcmToken(widget.myGift.userID);
        NotificationService.sendNotification('Someone Just Pledged you gift', fcmToken, 'A new Pledge!!');
      } else {
        FcmServices().sendFCMMessage('Someone unpledged!!', 'Did you hurt them? Go buy them a gift and say sorry', widget.myGift.userID);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pledge action was successful!')),
      );


      setState(() {
        isPledged = newPledgeStatus;
        isPledgedByUser = newPledgeByUserStatus;
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to perform pledge action: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pledgeAction,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 300,
        height: 75,
        decoration: BoxDecoration(
          color: isPledged
              ? isPledgedByUser
              ? CupertinoColors.activeGreen
              : CupertinoColors.activeGreen
              : CupertinoColors.inactiveGray,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.5),
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
