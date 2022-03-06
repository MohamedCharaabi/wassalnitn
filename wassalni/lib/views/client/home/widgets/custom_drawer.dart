import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  ValueChanged<int> onTap;

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive(context);

    return Container(
      height: _responsive.height,
      width: _responsive.getWidth(0.8),
      padding: const EdgeInsets.all(15.0),
      // color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [
                0.1,
                0.9
              ],
              colors: [
                background.withOpacity(0.8),
                background,
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text("Home"),
              onTap: () {
                onTap(0);
                // close drawer
                Navigator.pop(context);
              },
              textColor: white,
            ),
            ListTile(
              leading: const Icon(
                Icons.chat,
                color: Colors.white,
              ),
              title: const Text("Chat"),
              onTap: () {
                // close drawer
                onTap(1);
                Navigator.pop(context);
              },
              textColor: white,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text("Logout"),
              onTap: () async {
                log('outing ...');
                await _authenticationService.signOut(context);
                context.read<UserProvider>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/signin', (Route<dynamic> route) => false);
              },
              textColor: white,
            ),
          ],
        ),
      ),
    );
  }
}
