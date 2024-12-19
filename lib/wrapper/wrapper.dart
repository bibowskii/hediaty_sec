import 'package:flutter/material.dart';
import 'package:hediaty_sec/screens/login/loginPage.dart';
import 'package:hediaty_sec/widgets/customNavBar.dart';
import 'package:provider/provider.dart';

import '../providers/is_logged_in_provider.dart';



class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccessTokenProvider>(
        builder: (context, accessTokenProvider, _) {

          if (accessTokenProvider.accessToken == null || accessTokenProvider.accessToken!.isEmpty) {
            return loginPage(); // User is not logged in
          } else {
            return CustomNavBar(); // User is logged in
          }
        },
      ),
    );
  }
}
