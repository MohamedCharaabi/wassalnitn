import 'package:flutter/material.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/utils/constants.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final AuthenticationService _authenticationService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: MaterialButton(
      color: white,
      onPressed: () async {
        await _authenticationService.signOut(context);
        context.read<UserProvider>().logout();
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/signin', (Route<dynamic> route) => false);
      },
      child: const Text("Logout"),
    ));
  }
}
