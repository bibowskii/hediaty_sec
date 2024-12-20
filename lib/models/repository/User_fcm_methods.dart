import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/fcm.dart';
import 'package:hediaty_sec/services/firebase_services.dart';
import 'package:hediaty_sec/services/user_manager.dart';

class UserFcmMethods {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<String> getUserFcmToken(String userID) async {
    var token= await instance.collection(collections().UserFc).doc(userID).get();
    return token['FCMTOken'];
  }
Future <void> SaveFCMToken(String token) async {
  Map<String, dynamic> myPlayerData = {'FCMTOken': token};
  await instance.collection(collections().UserFc).doc(UserManager().getUserId()).set(myPlayerData, SetOptions(merge: true));
}

Future<void> deleteFCMToken(String userID) async {
  await instance.collection(collections().UserFc).doc(UserManager().getUserId()).delete();
}


}