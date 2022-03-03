import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/views/screens/messages/chat_page.dart';
import 'package:wassalni/views/rider/pages/home_page.dart';
import 'package:wassalni/views/rider/pages/notification_page.dart';
import 'package:wassalni/views/rider/pages/settings_page.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({Key? key}) : super(key: key);

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _page = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    const NotificationPage(),
    SettingPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.amber,
        index: _page,
        items: [
          Icon(Icons.home, size: 30, color: white),
          Icon(Icons.chat, size: 30, color: white),
          Icon(Icons.notifications, size: 30, color: white),
          Icon(Icons.settings, size: 30, color: white),
        ],
        color: mainColor,
        backgroundColor: background,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pages[_page],
    );
  }
}
