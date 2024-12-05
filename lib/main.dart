import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/is_logged_in_provider.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/splash_screen/splash_screen.dart';
import 'package:hediaty_sec/services/shared_prefs_service.dart';
import 'package:hediaty_sec/wrapper/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => isLogged()),
    ChangeNotifierProvider(create: (context) => theme()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  final bool darkMode = false;

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:
            context.watch<theme>().dark ? ThemeData.dark() : ThemeData.light(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
/*      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),*/
      initialRoute: '/', // Initial route
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => AuthWrapper(),
      },
       // home: AuthWrapper() //const AuthWrapper(),
        );
  }
}
