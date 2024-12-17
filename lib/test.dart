import 'package:flutter/material.dart';
import 'package:hediaty_sec/services/unused/one_signal_service.dart';
import 'package:hediaty_sec/services/shared_prefs_service.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPrefs().init();
  print("Shared Preferences initialized");

  // Initialize Firebase
  await Firebase.initializeApp();
  print("Firebase initialized");

  // Load user data
  await UserManager().loadUser();
  print("User data loaded");

  OneSignal.login(UserManager().getUserId()!);
  try {
    // Check if the user is already signed in, otherwise sign in
    if (FirebaseAuth.instance.currentUser == null) {
      print("User not signed in, signing in...");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'biboyasser3@gmail.com',
        password: 'bedo02',
      );
      print("User signed in");
    } else {
      print("User already signed in");
    }
  } catch (e) {
    print('Error signing in: $e');
  }

  // Initialize OneSignal
  try {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize('18b4199f-308a-4310-b683-fb99a2c7e060');
    print("OneSignal initialized");

    // Request notification permission
    OneSignal.Notifications.requestPermission(true);
    print("Notification permission requested");
  } catch (e) {
    print("Error initializing OneSignal: $e");
  }

  // Initialize OneSignalServices for sending push notifications
  OneSignalServices oneSignalService = OneSignalServices();

  try {
    // Retrieve and log the device's OneSignal player ID
    OneSignal.User.getOnesignalId().then((deviceState) {
      String? playerId = deviceState;
      print('OneSignal Player ID: $playerId');

      if (playerId != null) {
        // Save the OneSignal player ID for the current user
        oneSignalService.saveOneSignalPlayerId(playerId);
        print("Player ID saved");

        // Test push notification by sending it to the current user's player ID
        oneSignalService.pushNotification(
          UserManager().getUserId()!,
          'Test Notification',
          'Hello, this is a test push notification using OneSignal.',
        );
        print("Test push notification sent");
      } else {
        print('Player ID is null, cannot send notification');
      }
    }).catchError((e) {
      print('Error retrieving OneSignal Player ID: $e');
    });
  } catch (e) {
    print('Error in OneSignal notification setup: $e');
  }

  /*// Optional: Handle incoming notifications when the app is in the foreground
  OneSignal.shared.setNotificationReceivedHandler((notification) {
    print('Received notification: ${notification.title}, ${notification.body}');
  });

  // Optional: Handle notification opening when the app is opened from a notification
  OneSignal.shared.setNotificationOpenedHandler((result) {
    print('Notification opened: ${result.notification.payload.title}, ${result.notification.payload.body}');
  });*/
}
