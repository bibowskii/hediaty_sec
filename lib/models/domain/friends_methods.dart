import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/friends_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

final FirestoreService _firestoreService = FirestoreService();

class Follow implements friendsRepo {
  @override
  Future<bool> followFriend(Friend myFriend) async {
    try {
      await _firestoreService.addData(collections().friends, myFriend.toMap());
      return true;
    } catch (e) {
      print('Error following friend: ${e.toString()}');

      return false;}

  }

  @override
  Future<Map<String, dynamic>?> getFriend(Friend myFriend) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().friends, 'UserID', myFriend.UserID);
      if (docID != null) {
        return await _firestoreService.getDocument(collections().user, docID);
      }
      return null;
    } catch (e) {
      print('Error getting friend: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<bool> removeFriend(Friend myFriend) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().friends, 'UserID', myFriend.UserID);
      if (docID != null) {
        await _firestoreService.deleteDocWith2Attributes(collections().friends, 'UserID', myFriend.UserID, 'FriendID', myFriend.FriendID);

      }
      return true;
    } catch (e) {
      print('Error removing friend: ${e.toString()}');
      return false;
    }
  }

  // Fetch friends' details based on their IDs
  Future<List<Map<String, dynamic>>> getListFriends(User myUser) async {
    try {
      // Fetch the list of friends' IDs
      List<Map<String, dynamic>> friendsListData =
          await _firestoreService.getList(
        collections().friends,
        'UserID',
        myUser.id,
      );

      // Fetch the details of each friend
      List<Map<String, dynamic>> friendsData = [];

      for (var friendData in friendsListData) {
        String friendID = friendData[
            'FriendID']; // Assume the 'friendID' field in the friend data

        // Fetch details for each friend
        Map<String, dynamic>? friendDetails = await _firestoreService
            .getDocumentByAttribute(collections().user, 'id', friendID);

        if (friendDetails != null) {
          friendsData.add(friendDetails);
        } else {
          print('No data found for friend ID: $friendID');
        }
      }

      return friendsData;
    } catch (e) {
      print('Error fetching friends list: ${e.toString()}');
      return [];
    }
  }

  Future<bool> isFriend(String myUserID, String friendID) async {
   try{
    bool isFriend = await _firestoreService.checkIfDocExistsWith2Attributes(collections().friends, 'UserID', myUserID, 'FriendID', friendID);
    return true;
   }catch(e){
    print('Error checking if friend: ${e.toString()}');
    return false;
   }
  }

  Future<List<Map<String, dynamic>>> getFollowers(String UserID)async{
    try{
      List<Map<String, dynamic>> followers = await _firestoreService.getList(collections().friends, 'FriendID', UserID);
      return followers;
    }catch(e){
      print('Error getting followers: ${e.toString()}');
      return [];
    }

  }
}
