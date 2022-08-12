import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  LocalDB();

  // getters.
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    return token;
  }

  // setters.
  Future<bool> setUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    final success = await prefs.setString('token', token);

    return success;
  }
}
