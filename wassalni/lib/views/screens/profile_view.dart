// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/views/client/home/widgets/custom_drawer.dart';

class ProfielView extends StatelessWidget {
  const ProfielView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0.0,
          leading: Container(),
          centerTitle: true,
          title: Text(
            "Profile Viewer",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Recent Viewer",
                  style: TextStyle(color: Colors.black),
                ),
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20.0)),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            new SizedBox(
              height: 10.0,
              child: new Center(
                child: new Container(
                  margin:
                      new EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: GridView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("assets/user.png"),
                            ),
                            Positioned(
                              right: 5,
                              bottom: 0,
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        width: 3)),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Nader Guesmi",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.redAccent,
                                    ),
                                    Opacity(
                                      opacity: 0.64,
                                      child: Text(
                                        "Tunisia,Tunis",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 20,
                ),
              ),
            )
          ],
        ));
  }
}
