import 'package:flutter/cupertino.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';

class GiftDetailsController{
 static final GiftDetailsController instance = GiftDetailsController._();

  GiftDetailsController._();

  bool isPledged= false;
  bool isPledgedByUser = false;
  /*late Gift G;*/


  Future<bool> checkIfPledged(Gift myGift)async {
    var gift = await giftMethods().getOneGift(myGift);
    var G = Gift.fromMap(gift!);
  try{
    if(G.pledgedBy == '' || G.pledgedBy == null){isPledged =false;}else{isPledged= true;}
    return isPledged;
  }
  catch(e){
    debugPrint(e.toString());
    return isPledged;
  }
  }

  Future<bool> checkIfPledgedByUser(Gift myGift)async {
    var gift = await giftMethods().getOneGift(myGift);
    var G = Gift.fromMap(gift!);
    if(G.pledgedBy == UserManager().getUserId()){isPledgedByUser=true;}else{isPledgedByUser=false;};
    return isPledgedByUser;
  }


}