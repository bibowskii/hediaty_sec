import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';

import '../../models/data/users.dart';

class EventListController{
  static final EventListController instance = EventListController._();

  EventListController._();

  List<Event> eventList =[];


  Future<void> getEventList() async{
    try{
      var userID = UserManager().getUserId();
      var userMap = await userMethods().getUserByID(userID!);
      var user = User.fromMap(userMap!);
      if (user != null){
        final events = await eventMethods().getListEvents(user);
        eventList = events.map<Event>((event)=> Event.fromMap(event)).toList();

      }
      else{
        throw Exception('User is not logged in.');
      }
    }catch(e){
      print(e.toString());
    }

}


}