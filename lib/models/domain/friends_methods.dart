import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/repository/friends_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

final FirestoreService _firestoreService = FirestoreService();

class Follow implements friendsRepo {
  @override
  followFriend(Friend myFriend) {
    try {
      _firestoreService.addData(collections().friends, myFriend.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  getFriend(Friend myFriend) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().friends, 'userId', myFriend.UserID);
      _firestoreService.getDocument(collections().user, docID!);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  removeFriend(Friend myFriend)async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().friends, 'userId', myFriend.UserID);
      _firestoreService.deleteData(collections().friends, docID!);
    } catch (e) {
      print(e.toString());
    }
  }

  /*Future <void> getListFriends(Friend myFriend) async{
    try{
     List<Friend> friendsList = await _firestoreService.getList(collections().friends, 'userId', myFriend.UserID);
    }catch(e){
      print(e.toString());
    }
  }*/

  Future<List<Friend>> getListFriends(Friend myFriend) async {
    try {
      List<Map<String, dynamic>> friendsListData = await _firestoreService.getList(
          collections().friends,
          'userId',
          myFriend.UserID
      );


      // Convert each Map<String, dynamic> into a Friend object
      return friendsListData
          .map((friendData) => Friend.fromMap(friendData))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

}
