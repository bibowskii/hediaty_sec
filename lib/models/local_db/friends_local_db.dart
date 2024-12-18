import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/friends_repo.dart';
import 'db_helper.dart';

final SQLiteService _sqliteService = SQLiteService();

class Follow implements friendsRepo {
  @override
  Future<bool> followFriend(Friend myFriend) async {
    try {
      await _sqliteService.insert(
        collections().friends,
        myFriend.toMap(),
      );
      return true;
    } catch (e) {
      print('Error following friend: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getFriend(Friend myFriend) async {
    try {
      List<Map<String, dynamic>> result = await _sqliteService.queryByAttribute(
        collections().friends,
        'UserID',
        myFriend.UserID,
      );
      if (result.isNotEmpty) {
        String friendID = result[0]['FriendID'];
        // Now, get the details of the friend by their ID
        return await _sqliteService.queryById(collections().user, friendID);
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
      await _sqliteService.deleteByAttributes(
        collections().friends,
        {
          'UserID': myFriend.UserID,
          'FriendID': myFriend.FriendID,
        },
      );
      return true;
    } catch (e) {
      print('Error removing friend: ${e.toString()}');
      return false;
    }
  }

  // Fetch friends' details based on their IDs
  @override
  Future<List<Map<String, dynamic>>> getListFriends(User myUser) async {
    try {
      List<Map<String, dynamic>> friendsListData = await _sqliteService.queryByAttribute(
        collections().friends,
        'UserID',
        myUser.id,
      );

      // Fetch the details of each friend
      List<Map<String, dynamic>> friendsData = [];

      for (var friendData in friendsListData) {
        String friendID = friendData['FriendID']; // Assuming 'FriendID' field in the data

        // Fetch details for each friend
        Map<String, dynamic>? friendDetails = await _sqliteService.queryById(
          collections().user,
          friendID,
        );

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
    try {
      List<Map<String, dynamic>> result = await _sqliteService.queryByAttribute(
        collections().friends,
        'UserID',
        myUserID,
      );

      for (var friend in result) {
        if (friend['FriendID'] == friendID) {
          return true; // Found a matching friend relationship
        }
      }
      return false; // No match found
    } catch (e) {
      print('Error checking if friend: ${e.toString()}');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getFollowers(String userID) async {
    try {
      List<Map<String, dynamic>> followers = await _sqliteService.queryByAttribute(
        collections().friends,
        'FriendID',
        userID,
      );
      return followers;
    } catch (e) {
      print('Error getting followers: ${e.toString()}');
      return [];
    }
  }
}
