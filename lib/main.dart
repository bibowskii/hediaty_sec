import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/keys/api_keys.dart';
import 'package:hediaty_sec/models/local_db/db_helper.dart';
import 'package:hediaty_sec/providers/is_logged_in_provider.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/splash_screen/splash_screen.dart';
import 'package:hediaty_sec/services/shared_prefs_service.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/wrapper/wrapper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await Firebase.initializeApp();
  await UserManager().loadUser();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(APIKeys().oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);
  final dbHelper = DatabaseHelper();




  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AccessTokenProvider()),
    ChangeNotifierProvider(create: (context) => theme()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  final bool darkMode = false;

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:
            context.watch<theme>().dark ? ThemeData.dark() : ThemeData.light(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => AuthWrapper(),
      },
      builder: (context, child) {
        return MediaQuery.withClampedTextScaling(
          child: child!,
          minScaleFactor: 0.7,
          maxScaleFactor: 1.0,
        );

      },
        );
  }
}
