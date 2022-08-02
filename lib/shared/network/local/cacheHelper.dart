import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences!.setDouble(key, value);
    } else if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    }
    return await sharedPreferences!.setString(key, value);
  }

  static dynamic getData({required String key}) {
    if (sharedPreferences != null) {
      return sharedPreferences!.get(key);
    } else {
      return null;
    }
  }

  static Future<bool> deleteData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }
}
