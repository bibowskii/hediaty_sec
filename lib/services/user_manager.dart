import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hediaty_sec/models/data/users.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() {
    return _instance;
  }

  User? currentUser;
  final userMethods _userMethods = userMethods();  // Instance of UserMethods

  UserManager._internal();

  // Load user from SharedPreferences when the app starts
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('currentUser');
    if (userJson != null) {
      currentUser = User.fromMap(json.decode(userJson));
    }
  }

  // Set the user by id and fetch the rest of the data
  Future<void> setUser(String userId) async {
    // Fetch user data using UserMethods
    Map<String, dynamic>? userData = await _userMethods.getUserByID(userId);
    if (userData != null) {
      // Create User object with the fetched data
      currentUser = User.fromMap(userData);

      // Save the user in SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('currentUser', json.encode(currentUser?.toMap()));
    }
  }

  // Get current user
  User? getUser() {
    return currentUser;
  }

  // Clear current user
  Future<void> clearUser() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
  }
}
