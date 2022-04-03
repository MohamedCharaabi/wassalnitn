import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/modelView/services/permission.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:wassalni/utils/styles.dart';
import 'package:wassalni/views/client/home/widgets/default_map.dart';
import 'package:location/location.dart' as loc;
import 'package:wassalni/views/client/home/widgets/ride_button.dart';

class HomePageClient extends StatefulWidget {
  const HomePageClient({Key? key}) : super(key: key);

  @override
  State<HomePageClient> createState() => _HomePageStateClient();
}

class _HomePageStateClient extends State<HomePageClient> {
  bool minSize = true;
  String _selectedDropType = 'Now';

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

    _stream = _firestore.collection('users').snapshots();
    _stream
        .map((event) => event.docs.map((doc) => doc.data()).toList())
        .listen((data) => {
              setState(() {
                users = List<UserModel>.from(
                    data.map((e) => UserModel.fromJson(e)));
              }),
              log('${users.length}'),
            });
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

    locationPermissionHandler();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive(context);

    return SizedBox(
      child: Stack(
        children: [
          SizedBox(
            height: _responsive.getHeight(.6),
            /*  */
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // heading
                Expanded(
                  child: Container(
                    // height: _responsive.getHeight(0.2),
                    width: _responsive.width,
                    decoration: BoxDecoration(
                      // color: mainColor,
                      gradient: default_gradient(),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Welcome to Wasalni",
                            style: text_bold.copyWith(
                                fontSize: _responsive.isSmallScreen()
                                    ? 18.sp
                                    : 26.sp)),
                        Text(
                            "Happy to have you access your trips in just a tap.",
                            style: text_bold.copyWith(fontSize: 16.sp))
                      ],
                    ),
                  ),
                ),
                verticalSpace(5.0),

                //  2 buttons (ride, intercity)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _responsive.getResponsiveWidth(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                          child:
                              RideButton(text: 'Ride', goTo: 'request_ride')),
                      horizontalSpace(10),
                      Flexible(
                        child:
                            RideButton(text: 'Intercity', goTo: 'request_ride'),
                      )
                    ],
                  ),
                ),
                verticalSpace(5.0),

                //  where to search
                Container(
                    padding: EdgeInsets.only(
                      left: _responsive.getResponsiveWidth(15.0),
                      top: _responsive.getResponsiveHeight(18.0),
                      bottom: _responsive.getResponsiveHeight(18.0),
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: _responsive.getResponsiveWidth(15.0)),
                    decoration: BoxDecoration(
                      gradient: default_gradient(horizontal: true),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Where To?",
                          style: text_bold,
                        ),
                        Container(
                            // padding: EdgeInsets.all(
                            //     _responsive.getResponsiveWidth(5)),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.alarm,
                                  color: mainColor,
                                ),
                                DropdownButton(
                                    value: _selectedDropType,
                                    iconDisabledColor: mainColor,
                                    iconEnabledColor: mainColor,
                                    underline:
                                        const SizedBox(), // Hide the underline
                                    hint: Text(_selectedDropType,
                                        style: text_bold.copyWith(
                                            color: background)),
                                    items: const [
                                      DropdownMenuItem(
                                          child: Text('Now'), value: 'Now'),
                                      DropdownMenuItem(
                                          child: Text('Schedled'),
                                          value: 'Schedled'),
                                    ],
                                    onChanged: (String? val) {
                                      setState(() {
                                        _selectedDropType = val ?? 'Now';
                                      });
                                    }),
                              ],
                            ))
                      ],
                    )),
                verticalSpace(10.0),

                // saved places
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: _responsive.getResponsiveWidth(15.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.star, color: background),
                            ),
                            horizontalSpace(5),
                            Text("Choose a saved place", style: text_normal),
                          ],
                        ),
                        Icon(Icons.chevron_right_rounded, color: white),
                      ],
                    )),

                // verticalSpace(5.0),
                // arround me
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _responsive.getResponsiveWidth(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Around Me", style: text_bold),
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
                ),
                verticalSpace(15.0),
              ],
            ),
          ),
          Align(
            // height: _responsive.getHeight(.3),
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
