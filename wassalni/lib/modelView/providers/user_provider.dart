import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wassalni/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserProvider(this._currentUser);

  UserModel? get currentUser => _currentUser;

  set changeUser(UserModel? user) {
    log('user setted $user');
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
