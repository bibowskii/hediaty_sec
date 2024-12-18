/*
import 'package:flutter/material.dart';
import 'package:hediaty_sec/services/shared_prefs_service.dart';

class isLogged extends ChangeNotifier {
  bool _isLoggedIn = SharedPrefs().getBool('logged') ?? false;


  bool get isLoggedIn => _isLoggedIn;

  void changeState() {
    _isLoggedIn = !_isLoggedIn;
    SharedPrefs().saveBool('logged', _isLoggedIn);
    notifyListeners();
  }
}
*/
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AccessTokenProvider with ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  AccessTokenProvider() {
    _loadAccessToken();  // Load token when the provider is created
  }

  // Load the access token from SharedPreferences
  Future<void> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');  // Load token from memory
    notifyListeners();  // Notify listeners once the token is loaded
  }

  Future<void> setAccessToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);  // Save token to SharedPreferences
    notifyListeners();
  }

  Future<void> clearAccessToken() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');  // Remove token from SharedPreferences
    notifyListeners();
  }
}
