import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:location/location.dart' as loc;

import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class DefaultMap extends StatefulWidget {
  const DefaultMap({Key? key, this.minSize = true, this.arroundMe = false})
      : super(key: key);

  final bool minSize;
  final bool arroundMe;
  @override
  _DefaultMapState createState() => _DefaultMapState();
}

class _DefaultMapState extends State<DefaultMap> {
  // Activate Arround Me
  bool _arroundMe = false;
  final loc.Location location = loc.Location();

  Completer<GoogleMapController> _googleMapController = Completer();
  LatLng _center = LatLng(36.3998135, 10.0325908);

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
  }

  // makers
  final List<Marker> _markers = <Marker>[];
  //
  final _firestore = FirebaseFirestore.instance;

  late Stream stream;
  late Geoflutterfire geo;
  late List<UserModel> users;

  _getAroundMe() async {
    log('Geting around me..');

    // var position = await location.getLocation();
    // double? lat = position.latitude;
    // double? lng = position.longitude;

    // log('current Lat: $lat');

    // stream = _firestore.collection('users').get();
    stream = _firestore.collection('users').snapshots();
    stream
        .map((event) => event.docs.map((doc) => doc.data()).toList())
        .listen((data) => {
              // setState(() {
              debugPrint('data: $data'),
              users =
                  List<UserModel>.from(data.map((e) => UserModel.fromJson(e))),
              // }),
              // log('${users.length}'),
              _updateMakers(users),
            });
  }

  @override
  void initState() {
    _arroundMe = widget.arroundMe;
    super.initState();
    getMyLocation();
    _getAroundMe();
  }

  void getMyLocation() async {
    LocationData myLoc = await location.getLocation();
    setState(() {
      _center = LatLng(myLoc.latitude!, myLoc.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.minSize
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Center(
        child: Stack(children: [
          GoogleMap(
            markers: Set<Marker>.of(_markers),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(zoom: 15.0, target: _center),
            myLocationEnabled: true,
          ),
        ]),
      ),
    );
  }

  void _updateMyLocationCamera(
      {required double lat, required double long}) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15.0, bearing: 0.0, tilt: 0.0)));
  }

  void _updateMakers(List<UserModel> documents) async {
    // List<UserModel> documents = [];
    documents.forEach((element) {
      GeoFirePoint? geoPoint = element.position;
      String? _currentUserId =
          Provider.of<UserProvider>(context, listen: false).currentUser?.uid;

      if (geoPoint != null && element.uid != _currentUserId) {
        _addMarker(
            id: element.uid!,
            title: element.name!,
            snippet: 'bla bla bla',
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

  _addMarker(
      {required String id,
      required String title,
      required String snippet,
      required GeoPoint position,
      bool isCurrentUser = false}) async {
    final Uint8List customMarker = await getBytesFromAsset(
        path: 'assets/images/car.png', //paste the custom image path
        width: 50 // size of custom image as marker
        );
    var marker = Marker(
        markerId: MarkerId(id),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(customMarker),
        // icon: BitmapDescriptor.defaultMarkerWithHue(isCurrentUser
        //     ? BitmapDescriptor.hueGreen
        //     : BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: title, snippet: snippet));

    setState(() {
      _markers.add(marker);
    });
  }
}
