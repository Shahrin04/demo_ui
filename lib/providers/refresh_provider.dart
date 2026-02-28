import 'package:flutter/material.dart';

class RefreshProvider with ChangeNotifier {
  bool refresh = false;

  bool get getRefresh => refresh;

  void refreshDone() {
    refresh = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      refresh = false;
    });
  }
}
