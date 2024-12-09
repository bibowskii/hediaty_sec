import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/screens/event_list/event_list_controller.dart';

import '../../models/data/Event.dart';
import '../../models/data/Gifts.dart';

class EventDetailsController{

  static final EventDetailsController instance = EventDetailsController._();
  EventDetailsController._();

  List<Gift> gifts = [];

  Future<void> getGifts(Event myEvent) async{
   try {
     var giftMap = await giftMethods().getGiftsForEvent(myEvent);
     gifts = giftMap.map<Gift>((gift) => Gift.fromMap(gift)).toList();
   }catch(e) {
     print(e.toString());

   }
  }





}