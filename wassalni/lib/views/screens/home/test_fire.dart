import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wassalni/models/user_model.dart';

class TestFire extends StatefulWidget {
  const TestFire({Key? key}) : super(key: key);

  @override
  _TestFireState createState() => _TestFireState();
}

class _TestFireState extends State<TestFire> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream stream;

  getUsers() {
    stream = _firestore.collection('users').snapshots();
    stream
        .map((event) => event.docs.map((doc) => doc.data()).toList())
        .listen((data) => {
              data.forEach((element) {
                UserModel user = UserModel.fromJson(element);
                log('element: ${user.position!.longitude}, ${user.position!.latitude}');
              })
            });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Container(),
    );
  }
}
