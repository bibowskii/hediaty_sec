import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/repository/User_fcm_methods.dart';
import 'package:hediaty_sec/screens/login/loginPage.dart';
import 'package:hediaty_sec/services/FCM_services.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/customNavBar.dart';
import 'package:provider/provider.dart';
import '../providers/is_logged_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});


  Future<void> _fetchAndStoreFcmToken(BuildContext context) async {
    try {

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String? token = await FirebaseMessaging.instance.getToken();
        if (token != null && UserManager().getUserId() != null) {
          await UserFcmMethods().SaveFCMToken(token);
          debugPrint("FCM Token fetched and stored: $token");
        }
        FcmServices().subscribeToTopic('news');
      }
    } catch (e) {
      debugPrint('Error fetching or storing FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccessTokenProvider>(
        builder: (context, accessTokenProvider, _) {
          if (accessTokenProvider.accessToken == null || accessTokenProvider.accessToken!.isEmpty) {
            return loginPage(); // User is not logged in
          } else {
            // Fetch FCM token and store it when the user logs in
            _fetchAndStoreFcmToken(context);
            return CustomNavBar(); // User is logged in
          }
        },
      ),
    );
  }
}
