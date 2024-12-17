import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hediaty_sec/keys/api_keys.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalServices {
  final String appId = APIKeys().oneSignalAppId;  // OneSignal App ID
  final String apiKey = APIKeys().oneSignalApiKey; // OneSignal REST API Key
  final String apiUrl = 'https://onesignal.com/api/v1/notifications'; // OneSignal API URL
  final String userId = UserManager().getUserId()!; // Assume we get the user ID from UserManager
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to send a notification to a specific user (using OneSignal)
  Future<void> pushNotification(String userID, String title, String body) async {
    try {
      // Retrieve the user's OneSignal player ID (device token)
      String? playerId = await getOneSignalPlayerId(userID);
      if (playerId == null) {
        print("Player ID not found for user: $userID");
        return;
      }

      // Log player ID to verify
      print("Sending notification to Player ID: $playerId");

      // Construct the payload for OneSignal API request
      final Map<String, dynamic> payload = {
        'app_id': appId,
        'include_player_ids': [playerId],
        'headings': {'en': title},
        'contents': {'en': body},
      };

      // Send the notification request to OneSignal API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $apiKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully via OneSignal');
      } else {
        print('Error sending notification: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Retrieve the OneSignal player ID (device token) for a friend/user from your Firestore database
  Future<String?> getOneSignalPlayerId(String userID) async {
    try {
      var playerData = await _db.collection(collections().UserFc).doc(UserManager().getUserId()).get();
      return playerData['onesignal_player_id']; // Assuming you store player ID in your Firestore DB
    } catch (e) {
      print("Error getting OneSignal player ID: $e");
      return null;
    }
  }

  // Save OneSignal Player ID for the current user
  void saveOneSignalPlayerId(String playerId) async {
    Map<String, dynamic> myPlayerData = {'onesignal_player_id': playerId};
    await _db.collection(collections().UserFc).doc(userId).set(myPlayerData, SetOptions(merge: true));
  }
  void getPlayerID() async {
    var id = OneSignal.User.pushSubscription.id;
  }
}
