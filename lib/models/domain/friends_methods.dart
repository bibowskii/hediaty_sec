//supposedly done

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/friends_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

final FirestoreService _firestoreService = FirestoreService();

class Follow implements friendsRepo {
  @override
 Future<void> followFriend(Friend myFriend) async{
    try {
      await _firestoreService.addData(collections().friends, myFriend.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<Map<String,dynamic>?> getFriend(Friend myFriend) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().friends, 'userId', myFriend.UserID);
      Map<String,dynamic>? friend = await _firestoreService.getDocument(collections().user, docID!);
    return friend;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> removeFriend(Friend myFriend)async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().friends, 'userId', myFriend.UserID);
      await _firestoreService.deleteData(collections().friends, docID!);
    } catch (e) {
      print(e.toString());
    }
  }


  Future<List<Friend>> getListFriendsIDs(User myUser) async {
    try {
      List<Map<String, dynamic>> friendsListData = await _firestoreService.getList(
          collections().friends,
          'userId',
          myUser.id
      );



      return friendsListData
          .map((friendData) => Friend.fromMap(friendData))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getListFriends(User myUser) async {
    try {

      List<Friend> friendsList = await getListFriendsIDs(myUser);
      List<Map<String, dynamic>> friendsData = [];

      // Loop through the list of friends
      for (var friend in friendsList) {
        try {

          Map<String, dynamic>? friendData = await _firestoreService.getDocumentByAttribute(
              collections().user,
              'id',
              friend.FriendID
          );

          if (friendData != null) {
            friendsData.add(friendData);
          } else {
            print('No data found for friend ${friend.FriendID}');
          }
        } catch (e) {
          print('Error fetching data for friend ${friend.FriendID}: ${e.toString()}');
        }
      }

      return friendsData; // Return the list of friend data
    } catch (e) {
      print('Error fetching friends list: ${e.toString()}');
      return [];
    }
  }




}
