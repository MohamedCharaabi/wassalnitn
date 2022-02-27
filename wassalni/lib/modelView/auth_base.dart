import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wassalni/models/user_model.dart';

abstract class AuthBase {
  Future<User?> currentUser();

  Future<String?> googleSignIn();

  // Future<String> facebookSignIn();
  Future<UserModel?> emailPassSignIn(
      String email, String password, BuildContext context);

  Future<String> googleSignUp();

  // Future<String> facebookSignUp();

  Future<String> emailPassSignUp(
      String username, String email, String password, BuildContext context);

  Future<void> signOut(BuildContext context);
}
