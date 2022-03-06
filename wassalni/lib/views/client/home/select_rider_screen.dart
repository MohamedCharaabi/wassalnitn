import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/main.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/location_service.dart';
import 'package:wassalni/modelView/services/ride_crud.dart';
import 'package:wassalni/models/ride_model.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/bitmap_from_asset.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:location/location.dart' as loc;
import 'package:wassalni/utils/styles.dart';

class SelectRiderScreen extends StatefulWidget {
  const SelectRiderScreen({
    Key? key,
    required this.startPoint,
    required this.destinationPoint,
  }) : super(key: key);

  final Marker startPoint;
  final Marker destinationPoint;

  @override
  State<SelectRiderScreen> createState() => _SelectRiderScreenState();
}

class _SelectRiderScreenState extends State<SelectRiderScreen> {
  // map
  final Completer<GoogleMapController> _mapController = Completer();
  final loc.Location _location = loc.Location();
//search
  // bool _openSearch = false;
  // String _searchAddress = '';

  GeoFirePoint? _destinationPoint;
  final LocationService _locationService = LocationService();
// markers
  Set<Marker> _markers = {};

// Selecte Driver
  UserModel? _selectedDriver;
  LatLng _center = LatLng(36.3998135, 10.0325908);

//
  bool _submitBtnLoading = false;
  final RideCrud _rideCrud = RideCrud();
// firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream stream;
  Geoflutterfire geo = Geoflutterfire();
  late List<UserModel> users;

  void getMyLocation() async {
    loc.LocationData myLoc = await _location.getLocation();
    setState(() {
      _center = LatLng(myLoc.latitude!, myLoc.longitude!);
    });
  }

  _getAroundMe() async {
    log("Arround me");
    stream = _firestore
        .collection('users')
        // get arround me users
        // .where('position',
        //     isGreaterThan: geo.point(
        //         latitude: _center.latitude - 0.1,
        //         longitude: _center.longitude - 0.1))
        // .where('position',
        //     isLessThan: geo.point(
        //         latitude: _center.latitude + 0.1,
        //         longitude: _center.longitude + 0.1))
        .snapshots();

    // log('${stream.first}');
    stream.map((event) => event.docs.map((doc) => doc.data()).toList()).listen(
        (data) => {
              // log('${data}'),
              // setState(() {
              // debugPrint('data: $data'),
              users =
                  List<UserModel>.from(data.map((e) => UserModel.fromJson(e))),
              // }),
              // log('${users.length}'),

              _updateMakers(users),
            },
        onError: (e) => log('error: $e'),
        onDone: () => log('done'),
        cancelOnError: false);
    // } else {
    //   _removeAllMarkers();
  }

  void _updateMyLocationCamera(
      {required double lat, required double long}) async {
    final GoogleMapController controller = await _mapController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15.0, bearing: 0.0, tilt: 0.0)));
  }

  _addMarker(
      {required String id,
      required String title,
      required String snippet,
      required GeoPoint position,
      bool isCurrentUser = false}) async {
    final Uint8List customMarker = await getBytesFromAsset(
        path: 'assets/images/car.png', //paste the custom image path
        width: 100 // size of custom image as marker
        );
    var marker = Marker(
        markerId: MarkerId(id),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(customMarker),
        onTap: () {
          setState(() {
            _selectedDriver = users.firstWhere((element) => element.uid == id);
          });
        },
        infoWindow: InfoWindow(title: title, snippet: snippet));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _updateMakers(List<UserModel> documents) async {
    // List<UserModel> documents = [];
    documents.forEach((element) {
      GeoFirePoint? geoPoint = element.position;
      String? _currentUserId =
          Provider.of<UserProvider>(context, listen: false).currentUser?.uid;
      // log('$element');
      if (geoPoint != null &&
          element.uid != _currentUserId &&
          // element.position!
          //         .distance(lat: _center.latitude, lng: _center.longitude) >
          //     .2 &&
          element.isDriver == true) {
        _addMarker(
            id: element.uid!,
            title: element.name!,
            snippet: element.phone ?? '',
            position: geoPoint.geoPoint,
            isCurrentUser: element.uid == _currentUserId);
      }

      if (element.uid == _currentUserId && geoPoint != null) {
        _updateMyLocationCamera(
            lat: geoPoint.latitude, long: geoPoint.longitude);
        // _googleMapController.moveCamera(CameraUpdate.newLatLng(
        //   LatLng(element.position!.latitude, element.position!.longitude),
        // ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMyLocation();
    _getAroundMe();
    _markers.addAll({widget.startPoint, widget.destinationPoint});
  }

  @override
  void didUpdateWidget(covariant SelectRiderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // log('${widget._startPoint.position.latitude}');
    // if (widget._startPoint != oldWidget._startPoint) _markers.clear();
    // _markers.add(widget._startPoint);
  }

  @override
  Widget build(BuildContext context) {
    String _userId = Provider.of<UserProvider>(context).currentUser!.uid!;

    Responsive _responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: const Text('Select Rider'),
      ),
      body: FutureBuilder<LatLng>(
          future: _locationService.getMyLocation(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Stack(
              children: <Widget>[
                // map
                GoogleMap(
                  markers: _markers,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: true,

                  initialCameraPosition: CameraPosition(
                    target: snapshot.data!,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  // onTap: (LatLng position) => setLocation(position)
                ),

// bottom fields
                Positioned(
                  bottom: 15,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _responsive.getWidth(0.05)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      // height: 0,
                      child: Column(
                        children: <Widget>[
                          //  selected driver

                          AnimatedContainer(
                            height: _selectedDriver != null
                                ? _responsive.getResponsiveHeight(60)
                                : 0,
                            width: _responsive.getWidth(0.9),
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: _selectedDriver != null
                                ? Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            _selectedDriver!.image ??
                                                'https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg'),
                                      ),
                                      horizontalSpace(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_selectedDriver!.name!),
                                          Text(_selectedDriver!.phone ??
                                              'no phone'),
                                        ],
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),

                          // continue button
                          InkWell(
                            onTap: () async {
                              if (_selectedDriver != null) {
                                setState(() {
                                  _submitBtnLoading = true;
                                });
                                final RideModel _ride = RideModel(
                                  user_id: _userId,
                                  driver_id: _selectedDriver!.uid!,
                                  start: GeoFirePoint(
                                      widget.startPoint.position.latitude,
                                      widget.startPoint.position.longitude),
                                  destination: GeoFirePoint(
                                      widget.destinationPoint.position.latitude,
                                      widget
                                          .destinationPoint.position.longitude),
                                );
                                bool result = await _rideCrud.addRequest(_ride);
                                setState(() {
                                  _submitBtnLoading = false;
                                });

                                if (result) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/home', (route) => false);
                                }
                              }
                            },
                            child: Container(
                              width: _responsive.getWidth(0.9),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _selectedDriver != null
                                    ? background
                                    : background.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerRight,
                              child: _submitBtnLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : SizedBox(
                                      width: _responsive.getWidth(0.55),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const <Widget>[
                                          Text(
                                            'Ask for a ride',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
