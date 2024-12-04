import '../data/friends.dart';

abstract class friendsRepo {
  getFriend(Friend myFriend);
  removeFriend(Friend myFriend);
  followFriend(Friend myFriend);
}
