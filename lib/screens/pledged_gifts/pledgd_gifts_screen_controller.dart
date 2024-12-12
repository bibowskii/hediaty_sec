import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import '../../models/data/users.dart';

class PledgdGiftsScreenController {
  static final PledgdGiftsScreenController instance = PledgdGiftsScreenController._();
  PledgdGiftsScreenController._();
  List<Gift> pledgedGifts = [];

  Future<void> GetMyPledgedGifts(String UserID) async {
    try {
      //var myUser = await userMethods().getUserByID(UserManager().currentUserId!);
      var gits = await giftMethods().getListPledges(UserID);

      pledgedGifts = gits.map((gift) => Gift.fromMap(gift)).toList();
      print(pledgedGifts);
    } catch (e) {
      print(e.toString());
    }
  }
}
