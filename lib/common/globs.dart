import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String url = 'http://192.168.1.107:3000/';
  
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('first_name');
  }

  static Future<String?> getType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('type');
  }

  static Future<String?> getUserNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  static Future<bool?> getIsSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSet');
  }

  static Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  static Future<int?> getKitchenId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('kitchen_id');
  }

  static Future<List<String?>> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstName = prefs.getString('first_name');
    String? lastName = prefs.getString('last_name');
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
    return [firstName, lastName, email, phone];
  }

  static Future<void> saveDataToSharedPreferences(String firstName, String lastName, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('phone', phone);
  }

  static Future<void> saveDataAfterSignin(int id, String firstName, String lastName, String email, String phone, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('type', type);
    await prefs.setBool('isSet', true);
  }

  static Future<void> saveKitchenName(String kitchenName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kitchen_name', kitchenName);
  }

  static Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isSet");
    await prefs.clear();
  }
}