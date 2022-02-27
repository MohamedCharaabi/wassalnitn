import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/around_me_provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthenticationService _authService = AuthenticationService();
  FirebaseCrud _userCrud = FirebaseCrud();
  final User? _authenticatedUser = await _authService.currentUser();
  log(' ${_authenticatedUser != null ? 'Authenticated' : 'Not Authenticated'}');
  final UserModel? userInfo = _authenticatedUser != null
      ? await _userCrud.getUserInfo(_authenticatedUser.uid)
      : null;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(userInfo)),
      ChangeNotifierProvider<AroundMeProvider>(
          create: (_) => AroundMeProvider()),
    ],
    child: MyApp(
      userIsAuthenticated: userInfo == null ? null : userInfo.isDriver,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.userIsAuthenticated}) : super(key: key);

  final bool? userIsAuthenticated;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    log('${widget.userIsAuthenticated}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: widget.userIsAuthenticated == false
          ? '/home'
          : widget.userIsAuthenticated == true
              ? '/driver_'
              : '/signin',
      routes: routes,
    );
  }
}
