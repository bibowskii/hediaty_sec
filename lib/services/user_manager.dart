import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() {
    return _instance;
  }

  String? currentUserId;

  UserManager._internal();


  Future<void> loadUser() async {
    final firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;

      _saveUserIdToPrefs(currentUserId);
    } else {

      _loadUserIdFromPrefs();
    }
  }


  Future<void> _saveUserIdToPrefs(String? userId) async {
    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('currentUserId', userId);
    }
  }


  Future<void> _loadUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('currentUserId');
  }


  Future<void> setUserId(String userId) async {
    currentUserId = userId;
    _saveUserIdToPrefs(currentUserId);
  }

  String? getUserId() {
    return currentUserId;
  }

  // Clear the user ID
  Future<void> clearUser() async {
    currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUserId');
    await firebase_auth.FirebaseAuth.instance.signOut();
  }

  // Check if the user is logged in
  Future<bool> isUserLoggedIn() async {
    var user = firebase_auth.FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
