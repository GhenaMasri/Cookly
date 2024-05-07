import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String url = 'http://192.168.1.105:3000/';
  
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('first_name');
  }

  static Future<String?> getType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('type');
  }

  static Future<bool?> getIsSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSet');
  }

  static Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isSet");
    await prefs.clear();
  }
}