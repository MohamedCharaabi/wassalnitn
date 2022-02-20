// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/modelView/services/permission.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/views/screens/home/widgets/default_map.dart';
import 'package:location/location.dart' as loc;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool minSize = true;

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  AuthenticationService _authenticationService = AuthenticationService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  GeoFirePoint? _oldPoint;
  StreamSubscription? _nearbyUsersSubscription;
  late Stream<List<DocumentSnapshot>> stream;
  late Stream _stream;
  late List users;

  _getAroundMe() async {
    log('Geting around me..');

    // var position = await location.getLocation();
    // double? lat = position.latitude;
    // double? lng = position.longitude;

    // log('current Lat: $lat');

    // stream = _firestore.collection('users').get();
    _stream = _firestore.collection('users').snapshots();
    _stream
        .map((event) => event.docs.map((doc) => doc.data()).toList())
        .listen((data) => {
              setState(() {
                users = List<UserModel>.from(
                    data.map((e) => UserModel.fromJson(e)));
              }),
              log('${users.length}'),

              // data.map((element, index) {
              //   UserModel user = UserModel.fromJson(element);
              //   log('user $index: ${user.position!.longitude}, ${user.position!.latitude}');
              // })
            });

    // // Make a referece to firestore
    // var ref = _firestore.collection('users');

    // GeoFirePoint center = geo.point(latitude: lat!, longitude: lng!);

    // // Get a stream of users within a radius of 50 km
    // Stream<List<DocumentSnapshot>> nearbyUserStream =
    //     geo.collection(collectionRef: ref).within(
    //           center: center,
    //           radius: 50,
    //           field: 'position',
    //           strictMode: true,
    //         );
    // log('message: $nearbyUserStream');
    // // Subscribe to the stream
    // _nearbyUsersSubscription =
    //     nearbyUserStream.listen((List<DocumentSnapshot> docList) {
    //   print('Current location: ${position.latitude}, ${position.longitude}');
    //   print('Nearby users:');
    //   docList.forEach((DocumentSnapshot doc) {
    //     print(doc.data());
    //   });
    // });

    // // Unsubscribe from the stream
    // // _nearbyUsersSubscription.cancel();

    // // Get all users within a radius of 50 km
  }

  changeLocation() async {
    final loc.LocationData newLocation = await location.getLocation();
    final GeoFirePoint newPoint = geo.point(
        latitude: newLocation.latitude!, longitude: newLocation.longitude!);
    log('newPoint: $newPoint');
    setState(() {
      _oldPoint = newPoint;
    });
  }

  @override
  void initState() {
    super.initState();

    locationPermissionHandler();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    // changeLocation();
    // _getAroundMe();
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser?.uid;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 8, 6, 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      MaterialButton(
                          color: Colors.white,
                          onPressed: () => _listenToLocation(),
                          child: Text('Start Listening')),
                      MaterialButton(
                          color: Colors.white,
                          onPressed: () async {
                            _authenticationService.signOut();
                            context.read<UserProvider>().logout();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/signin', (Route<dynamic> route) => false);
                          },
                          child: Text('Logout')),
                    ],
                  ),
                  MaterialButton(
                      onPressed: () => _stopListening(),
                      child: Text('Stop Listening')),
                  Expanded(
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                  const Text(
                    "lorem epsium",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  DefaultMap(
                    minSize: minSize,
                  ),
                  Positioned(
                    top: minSize ? 10 : 20,
                    right: 15,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: (() {
                          setState(() {
                            minSize = !minSize;
                          });
                        }),
                        icon: minSize
                            ? const Icon(Icons.fullscreen)
                            : const Icon(Icons.fullscreen_exit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenToLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((error) {
      log(error);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((locationData) async {
      String? _currentUserId =
          Provider.of<UserProvider>(context, listen: false).currentUser?.uid;

      if (locationData.latitude != null &&
          locationData.longitude != null &&
          _currentUserId != null) {
        // log('Updating location...');
        GeoFirePoint newPoint =
            GeoFirePoint(locationData.latitude!, locationData.longitude!);
        log('points:  $_oldPoint, $newPoint');
        if (_oldPoint != newPoint && _oldPoint != null
            // _oldPoint!
            //         .distance(lat: newPoint.latitude, lng: newPoint.longitude) >
            //     0.0002
            ) {
          await FirebaseCrud().updateLocation(newPoint, _currentUserId);
          setState(() {
            _oldPoint = newPoint;
          });
        }
      }
      // store new location
      log('${locationData.latitude}, ${locationData.longitude}');
    });
  }

  void _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
}
