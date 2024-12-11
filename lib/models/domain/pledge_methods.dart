//unused due to extra unneeded complexity

import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/gift_pledge.dart';
import 'package:hediaty_sec/models/repository/pledge_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

import '../data/users.dart';

class pledge implements pledgeRepo {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Future<void> pledgeGift(PledgedBy myPledge) async {
    try {
      await _firestoreService.addData(
          collections().giftPledge, myPledge.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> unpledgeGift(PledgedBy myPledge) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().giftPledge, 'userID', myPledge.giftID);

      await _firestoreService.deleteData(collections().giftPledge, docID!);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getListPledges(User myUser) async {
    List<Map<String, dynamic>> pledges = [];
    try {
      pledges = await _firestoreService.getList(
          collections().giftPledge, 'userID', myUser.id);
      print('pledged found');
      return pledges;
    } catch (e) {
      print(e.toString());
      return pledges;
    }
  }

  @override
  Future<Map<String, dynamic>> getPledge(Gift myGift) async {
    try {
      // Retrieve the document from Firestore based on the giftID
      Map<String, dynamic>? isPledged = await _firestoreService.getDocumentByAttribute(
          collections().giftPledge,
          'giftID',
          myGift.id
      );

      // If the document is null, return an empty map
      if (isPledged == null) {
        return {};
      }

      return isPledged;
    } catch (e) {
      // Log the error
      print('Error retrieving pledge: ${e.toString()}');

      // Return an empty map in case of an error
      return {};
    }
  }

}
