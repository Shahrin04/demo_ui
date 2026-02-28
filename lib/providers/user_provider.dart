import 'dart:developer' as d;
import 'package:demo_ui/config/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Future<void> logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.containsKey(LOGGED_TOKEN)) {
        await pref.remove(LOGGED_TOKEN);
      }
      notifyListeners();
    } on Exception catch (e) {
      String msg = "Error::UserProvider::logout: ${e.toString()}";
      d.log(msg);
    }
  }
}
