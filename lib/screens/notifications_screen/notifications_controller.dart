import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';

class NotificationsController {
  static final NotificationsController instance = NotificationsController._internal();

  NotificationsController._internal();

  List<Map<String, dynamic>> notifications = [];
  List<User> followers = [];
  List<User> pledgers = [];

  Future<List<User>> getNotifications() async {
    try {
      followers.clear();
      var friendsMap = await Follow().getFollowers(UserManager().getUserId()!);
      var followersList = friendsMap.map((map) => Friend.fromMap(map)).toList();

      // Fetch all follower profiles in parallel
      List<Future<User>> followerFutures = followersList.map((follower) async {
        dynamic friendProfile = await userMethods().getUserByID(follower.UserID!);
        return User.fromMap(friendProfile);
      }).toList();

      followers = await Future.wait(followerFutures);
    } catch (e) {
      // Handle error appropriately (log or return empty list)
      print('Error fetching followers: $e');
    }

    return followers;
  }

  Future<List<User>> getPledgers() async {
    try {
      pledgers.clear();
      var userMap = await userMethods().getUserByID(UserManager().getUserId()!);
      if (userMap == null) return [];

      User myUser = User.fromMap(userMap);
      var giftMap = await giftMethods().getGifts(myUser);
      var gifts = giftMap.map((map) => Gift.fromMap(map)).toList();

      // Fetch all pledger profiles in parallel
      List<Future<User>> pledgerFutures = gifts.map((gift) async {
        dynamic friendProfile = await userMethods().getUserByID(gift.pledgedBy!);
        return User.fromMap(friendProfile);
      }).toList();

      pledgers = await Future.wait(pledgerFutures);
    } catch (e) {
      // Handle error appropriately (log or return empty list)
      print('Error fetching pledgers: $e');
    }

    return pledgers;
  }
}
