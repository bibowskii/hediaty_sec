import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';


class FriendsListController {

  static final FriendsListController instance = FriendsListController._();


  FriendsListController._();


  List<User> friendsList = [];


  Future<void> getFriendsList() async {
    try {
      var userID = UserManager().getUserId();
      var userMap = await userMethods().getUserByID(userID!);
      var user = User.fromMap(userMap!);
      if (user == null) {
        throw Exception("User is not logged in.");
      }

      final rawFriends = await Follow().getListFriends(user);


      friendsList = rawFriends.map<User>((friend) => User.fromMap(friend)).toList();
    } catch (e) {

      print("Error fetching friends list: $e");


    }
  }
}
