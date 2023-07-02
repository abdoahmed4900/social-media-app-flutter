import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences prefs;
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
    debugPrint(CacheHelper.getString('uId'));
  }

  static Future<void> setBoolean(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  static String getString(String key) {
    return prefs.getString(key) ?? '';
  }

  static bool? getBoolean(String key) {
    return prefs.getBool(key) ?? false;
  }

  static void setBoardingScreen(bool value) async {
    await prefs.setBool('onBoarding', value);
  }

  static Future removeValue(String key) async {
    await prefs.remove(key);
  }
}
