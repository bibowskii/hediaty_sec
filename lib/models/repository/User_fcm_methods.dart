import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/fcm.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

class UserFcmMethods {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createFcmToken(UserFc myFcm) async {
    try {
    await _firestoreService.addData(collections().UserFc, myFcm.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> deleteFcmToken(UserFc myFcm) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().UserFc, 'id', myFcm.id);
      await _firestoreService.deleteData(collections().UserFc, docID!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editFcmToken(UserFc myFcm) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().UserFc, 'id', myFcm.id);
      await _firestoreService.updateData(collections().UserFc, docID!, myFcm.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

}