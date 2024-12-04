import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/repository/gifts_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

class giftMethods implements gifts_repo {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Future<void> createGift(Gift myGift) async {
    try {
      _firestoreService.addData(collections().gifts, myGift.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.deleteData(collections().gifts, docID!);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> editGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.updateData(
          collections().gifts, docID!, myGift.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> getGifts(Gift myGift) async {
    try {
      _firestoreService.getList(collections().gifts, 'userID', myGift.userID);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getOneGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.getDocument(collections().gifts, docID!);
    } catch (e) {
      print(e.toString());
    }
  }
}
