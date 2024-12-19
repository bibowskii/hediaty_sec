import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hediaty_sec/keys/api_keys.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/services/user_manager.dart';

class FcmServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void saveToken(String token) async {
    // UserFc myFC = UserFc(id: UserManager().getUserId()!, token: token);
    Map<String, dynamic> myToken = {'token': token};
    await _db
        .collection(collections().UserFc)
        .doc(UserManager().getUserId()!)
        .set(myToken);
  }

  Future<String?> getFcmTokenFriend(String userID) async {
    var fcmToken = await _db.collection(collections().UserFc).doc(userID).get();
    print('fcm token found');
    return fcmToken['token'];
  }


  Future<void> PushNotification(String userID, String title, String body) async {
    try {
      // Load the service account key JSON file
      final serviceAccountKeyFile = await rootBundle.loadString('lib/keys/hediaty-5941a-944a3c0e0c91.json'); // Path to your JSON key
     // final jsonKey = serviceAccountKeyFile.readAsStringSync();

      final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccountKeyFile);
      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      // Obtain the OAuth2 access token
      final client = await clientViaServiceAccount(accountCredentials, scopes);

      // Get the friend's FCM token
      String? token = await getFcmTokenFriend(userID);
      if (token == null) return;

      // Firebase Cloud Messaging v1 endpoint
      final projectId = APIKeys().AppID; // Replace with your Firebase project ID
      final url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

      // Construct the message payload
      final payload = {
        "message":{
          "token":token,
          "notification":{
            "title":"Portugal vs. Denmark",
            "body":"great match!"
          }
        }
      };


      // Send the POST request
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Check the response status
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Error sending notification: ${response.body}');
      }

      client.close(); // Close the client after use
    } catch (e) {
      print('Error: $e');

    }finally {

    }
  }

}
