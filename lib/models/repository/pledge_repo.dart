import 'package:hediaty_sec/models/data/gift_pledge.dart';

import '../data/Gifts.dart';
import '../data/users.dart';

abstract class pledgeRepo {
  pledgeGift(PledgedBy myPledge);
  unpledgeGift(PledgedBy myPledge);
  getListPledges(User myUser);
  getPledge(Gift myGift);
}
