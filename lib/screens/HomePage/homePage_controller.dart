// remove comment later when done with the ui
// comment for the filtering logic to make sure the event data is later and not and old event, to be specific in this month filtering

import 'package:hediaty_sec/models/data/event.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';

class HomePageController {
  List<Map<String, dynamic>> monthEvents = [];
  List<Map<String, dynamic>> yearEvents = [];
  List<Map<String, dynamic>> nextYearEvents = [];

  List<Map<String, dynamic>> monthEventsFriends = [];
  List<Map<String, dynamic>> yearEventsFriends = [];
  List<Map<String, dynamic>> nextYearEventsFriends = [];

  List<User> friendsThisMonth = [];
  List<User> friendsThisYear = [];
  List<User> friendsLater = [];

  Future<void> filterThisMonth(User myUser) async {
    Follow followMethods = Follow();
    eventMethods EventMethods = eventMethods();

    List<Map<String, dynamic>> unfilteredFriends =
    await followMethods.getListFriends(myUser);
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    await Future.wait(unfilteredFriends.map((friend) async {
      User userFriend = User.fromMap(friend);
      var events = await EventMethods.getListEvents(userFriend);

      for (var event in events) {
        Event curEvent = Event.fromMap(event);
        //remove comment later when done with the ui
        if (curEvent.date.month == currentMonth &&
            curEvent.date.year == currentYear /*&& curEvent.date.isAfter(DateTime.now())*/) {
          monthEvents.add(event);
        } else if (curEvent.date.year == currentYear /*&& curEvent.date.isAfter(DateTime.now())*/) {
          yearEvents.add(event);
        } else if (curEvent.date.year > currentYear) {
          nextYearEvents.add(event);
        }
      }
    }));
  }

  Future<void> filterFriends() async {
    userMethods userF = userMethods();
    //Set<User> fmonth={};
    for (var event in monthEvents) {
      Event curEvent = Event.fromMap(event);
      var user = await userF.getUserByID(curEvent.userID);
      /*fmonth.add(User.fromMap(user!));
      friendsThisMonth = fmonth.toList();*/

      monthEventsFriends.add(user!);
      friendsThisMonth = monthEventsFriends.map((map) => User.fromMap(map)).toSet().toList();

    }

    for (var event in yearEvents) {
      Event curEvent = Event.fromMap(event);
      var user = await userF.getUserByID(curEvent.userID);

      yearEventsFriends.add(user!);
      friendsThisYear = yearEventsFriends.map((map) => User.fromMap(map)).toSet().toList();
    }

    for (var event in nextYearEvents) {
      Event curEvent = Event.fromMap(event);
      var user = await userF.getUserByID(curEvent.userID);

      nextYearEventsFriends.add(user!);
      friendsLater = nextYearEventsFriends.map((map) => User.fromMap(map)).toSet().toList();
    }
  }

  Future <User?> getFriendsList(String number) async {
    try {
      User? myUser = await userMethods().FindUserByNumber(number);
      return myUser;
    }catch(e){
      print(e.toString());
    }
    }

}
