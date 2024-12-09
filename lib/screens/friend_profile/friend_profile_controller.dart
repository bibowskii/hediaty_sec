import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';

import '../../models/data/users.dart';

class FriendProfileController{
  static final FriendProfileController instance = FriendProfileController._();

  FriendProfileController._();

  List<Event> friendEvents =[];

  Future<void> getEvents(User myUser)async{
    try {
      var eventsMap = await eventMethods().getListEvents(myUser);
      friendEvents =
          eventsMap.map<Event>((event) => Event.fromMap(event)).toList();
    }catch(e){
      debugPrint(e.toString());
    }
  }






}