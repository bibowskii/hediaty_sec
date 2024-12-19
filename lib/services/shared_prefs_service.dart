import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static final SharedPrefs _instance = SharedPrefs._internal();


  factory SharedPrefs() => _instance;


  SharedPrefs._internal();

  late SharedPreferences _prefs;


  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }
}
