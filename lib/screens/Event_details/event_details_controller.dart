import 'package:hediaty_sec/models/domain/gift_methods.dart';

import '../../models/data/Event.dart';
import '../../models/data/Gifts.dart';

class EventDetailsController{

  static final EventDetailsController instance = EventDetailsController._();
  EventDetailsController._();

  List<Gift> gifts = [];
  bool isPledgded= false;
  Future<void> getGifts(Event myEvent) async{
   try {
     var giftMap = await giftMethods().getGiftsForEvent(myEvent);
     gifts = giftMap.map<Gift>((gift) => Gift.fromMap(gift)).toList();
   }catch(e) {
     print(e.toString());

   }
  }

  Future<void> checkIfPledged(Event myEvent) async {
    var gifts = await giftMethods().getGiftsForEvent(myEvent);

    if (gifts.isEmpty) {
      isPledgded = true;
      return;
    }

    for (var gift in gifts) {
      var k = Gift.fromMap(gift);
      if (k.pledgedBy != null || k.pledgedBy != '') {
        isPledgded = false;
        return; // Exit early since we found a pledged gift
      }
    }

    isPledgded = true;
  }






}