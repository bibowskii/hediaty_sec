import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? myToken;

  FirebaseMessagingService() {
    _initializeToken();
    _listenToTokenRefresh();
  }

  /// Initializes the Firebase token and prints it.
  Future<void> _initializeToken() async {
    try {
      myToken = await _firebaseMessaging.getToken();
      print('Firebase Token: $myToken');
    } catch (e) {
      print('Error fetching Firebase token: $e');
    }
  }

  /// Subscribes to a topic.
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribes from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Listens to token refresh events and updates the token.
  Future<void> _listenToTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      myToken = newToken;
      print('New Firebase Token: $newToken');
    });
  }

  /// Sends a notification to a specific token.
  /// The title and body parameters are the title and body of the notification.



  Future<void> sendNotificationToToken(String token, String title, String body) async {
    try {
      final String serverKey = 'YOUR_SERVER_KEY'; // Replace with your FCM Server Key

      // Construct the FCM message payload
      final Map<String, String> notification = {
        'title': title,
        'body': body,
      };

      final Map<String, dynamic> message = {
        'to': token,
        'notification': notification,
        'priority': 'high',
      };

      // Set headers for the request
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey', // Use your FCM Server Key
      };

      // Send the HTTP request to FCM
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headers,
        body: json.encode(message),
      );

      // Check the response status
      if (response.statusCode == 200) {
        print('Notification sent to token: $token');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification to token $token: $e');
    }
  }

}

