import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/services/user_manager.dart';

class NotificationsController {

  static NotificationsController instance = NotificationsController();

  NotificationsController();
  List<Map<String, dynamic>> notifications = <Map<String, dynamic>>[];
  List<User> followers = [];
  Future<List<User>> getNotifications() async {
   var friendsMap= await Follow().getFollowers(UserManager().getUserId()!);
    var followersList = friendsMap.map((map) => Friend.fromMap(map)).toList();
    for (var follower in followersList) {
      dynamic friendProfile = await userMethods().getUserByID(follower.UserID!);
      friendProfile = User.fromMap(friendProfile);
      followers.add(friendProfile);
    }
return followers;
  }

  List <User> pledgers = [];
  Future<List<User>> getPledgers() async {
    var userMap = await userMethods().getUserByID(UserManager().currentUserId!);
    User myUser = User.fromMap(userMap!);
    var giftMap = await giftMethods().getGifts(myUser);
    var gifts = giftMap.map((map) => Gift.fromMap(map)).toList();
    for (var gift in gifts) {
      dynamic friendProfile = await userMethods().getUserByID(gift.pledgedBy!);
      friendProfile = User.fromMap(friendProfile);
      pledgers.add(friendProfile);
    }
    return pledgers;
  }


}