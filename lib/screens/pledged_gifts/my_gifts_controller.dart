import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';

import '../../models/data/users.dart';

class MyGiftsScreenController {
  static final MyGiftsScreenController instance = MyGiftsScreenController._();
  MyGiftsScreenController._();
  List<Gift> myGifts = [];

  Future<void> GetMyPledgedGifts(String UserID) async {
    try {
      var myUserMap = await userMethods().getUserByID(UserManager().currentUserId!);
      User myUser = User.fromMap(myUserMap!);
      var gits = await giftMethods().getGifts(myUser);

      myGifts = gits.map((gift) => Gift.fromMap(gift)).toList();
      print(myGifts);
    } catch (e) {
      print(e.toString());
    }
  }
}
