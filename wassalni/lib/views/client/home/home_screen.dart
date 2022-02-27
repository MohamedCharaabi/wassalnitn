// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer'; /*  */
import 'dart:ffi';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/around_me_provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/modelView/services/permission.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:wassalni/views/client/home/widgets/custom_drawer.dart';
import 'package:wassalni/views/client/home/widgets/default_map.dart';
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

  bool _listenToNearbyRiders = false;

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

    // locationPermissionHandler();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    // changeLocation();
    // _getAroundMe();
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser?.uid;

    Responsive _responsive = Responsive(context);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: const Icon(Icons.menu),
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          // heading
                          Container(
                            color: mainColor,
                            height: _responsive.getHeight(0.2),
                            width: _responsive.width,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const <Widget>[
                                Text("Welcome to Wasalni",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "Happy to have you access your trips in just a tap.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                          ),
                          //  2 buttons (ride, intercity)
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RideButton(
                                  responsive: _responsive,
                                  text: 'Ride',
                                  goTo: 'request_ride'),
                              RideButton(
                                  responsive: _responsive,
                                  text: 'Intercity',
                                  goTo: 'request_ride')
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     const Text("Rider",
                          //         style: TextStyle(
                          //             color: Colors.white70,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 19.0)),
                          //     SizedBox(
                          //       child: Image.asset(
                          //         'assets/images/car.png',
                          //         height: 20,
                          //         width: 20,
                          //       ), // Your image widget here
                          //     ),
                          //     const Text("Driver",
                          //         style: TextStyle(
                          //             color: Colors.white70,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 19.0)),
                          //     SizedBox(
                          //       child: Image.asset(
                          //         'assets/images/car.png',
                          //         height: 20,
                          //         width: 20,
                          //       ), // Your image widget here
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Around Me",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Switch(
                          activeColor: mainColor,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          value: _listenToNearbyRiders,
                          onChanged: (value) {
                            value ? _UpdateLocation() : _stopListening();
                            // context.read<AroundMeProvider>().setAroundMe(value);
                            setState(() {
                              _listenToNearbyRiders = value;
                            });
                          }),
                    ],
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
                    listen: _listenToNearbyRiders,
                  ),
                  Positioned(
                    top: minSize ? 10 : 20,
                    left: 15,
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

  void _UpdateLocation() async {
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
// check if user moving
        GeoFirePoint newPoint = geo.point(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!);

        if (_oldPoint != newPoint && _oldPoint != null) {
          double distance = _oldPoint!
              .distance(lat: newPoint.latitude, lng: newPoint.longitude);
          if (distance >= 0.003) {
            await FirebaseCrud().updateLocation(newPoint, _currentUserId);
          }
        }
        setState(() {
          _oldPoint = newPoint;
        });
      }
    });
  }

  void _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
}

class RideButton extends StatelessWidget {
  RideButton(
      {Key? key,
      required Responsive responsive,
      required this.text,
      required this.goTo})
      : _responsive = responsive,
        super(key: key);

  final Responsive _responsive;
  final String text;
  // VoidCallback onPressed;
  final String goTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, goTo),
      child: Container(
          height: _responsive.getHeight(0.15),
          // width: _responsive.getWidth(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [mainColor, mainColor.withOpacity(0.1)],
              stops: const [0.1, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: <Widget>[
              Transform.rotate(
                angle: math.pi / 4,
                child: Image.asset(
                  'assets/images/car.png',
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 20, color: white),
              )
            ],
          )),
    );
  }
}
