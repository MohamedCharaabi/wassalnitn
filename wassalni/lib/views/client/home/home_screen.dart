// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer'; /*  */
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/around_me_provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/modelView/services/permission.dart';
import 'package:wassalni/models/Chat.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:wassalni/utils/styles.dart';
import 'package:wassalni/views/client/home/screens/chat_search.dart';
import 'package:wassalni/views/client/home/screens/home_page_client.dart';
import 'package:wassalni/views/client/home/widgets/custom_drawer.dart';
import 'package:wassalni/views/client/home/widgets/default_map.dart';
import 'package:location/location.dart' as loc;
import 'package:wassalni/views/client/home/widgets/ride_button.dart';
import 'package:wassalni/views/rider/pages/home_page.dart';
import 'package:wassalni/views/screens/messages/chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final List<Widget> _pages = const [HomePageClient(), ChatPage()];
  final List<String> _pageTitles = const [
    'Home',
    'Chat',
  ];

  void _changePage(int index) {
    setState(() {
      this.index = index;
    });
  }

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Chat');

  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser!;

    Responsive _responsive = Responsive(context);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: index == 1
            ? customSearchBar
            : Text(
                _pageTitles[index],
                style: TextStyle(color: white),
              ),
        actions: [
          // index == 1
          //     ? InkWell(
          //         onTap: () {
          //           log('Hi');
          //         },
          //         child: Icon(Icons.search),
          //       )
          //     : const SizedBox(),
          index == 1
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatSearch(
                                  searchForDriver: !currentUser.isDriver!,
                                )));
                  },
                  icon: customIcon,
                )
              : const SizedBox(),
        ],
      ),
      drawer: CustomDrawer(
        onTap: (int x) => _changePage(x),
      ),
      body: _pages[index],
    );
  }
}
