import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 250,),
            const Text(
              'Welcome to Hediaty',
              style: TextStyle(fontSize: 40, color: Colors.black),
            ),
            Spacer(),
            Image.asset(
                'lib/assets/icons/logo.png',
                fit: BoxFit.cover,
              ),


          ],
        ),
      ),
    );
  }
}
