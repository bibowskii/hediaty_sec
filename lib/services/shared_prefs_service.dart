import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Static instance of the class
  static final SharedPrefs _instance = SharedPrefs._internal();

  // Factory constructor to return the singleton instance
  factory SharedPrefs() => _instance;

  // Private named constructor
  SharedPrefs._internal();

  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Get a boolean value
  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }
}
