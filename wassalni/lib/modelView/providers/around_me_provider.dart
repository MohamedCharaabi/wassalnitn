import 'package:flutter/material.dart';

class AroundMeProvider extends ChangeNotifier {
  bool aroundMe = false;

  get getAroundMe => aroundMe;

  void setAroundMe(bool value) {
    aroundMe = value;
    notifyListeners();
  }
}
