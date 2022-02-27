import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wassalni/main.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:location/location.dart' as Loc;

class RequestRideScreen extends StatefulWidget {
  const RequestRideScreen({Key? key}) : super(key: key);

  @override
  _RequestRideScreenState createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Loc.Location _location = Loc.Location();

  bool _selectingStartPosition = true;
  GeoFirePoint? _startPoint;
  GeoFirePoint? _endPoint;

  Future<LatLng> getMyLocation() async {
    var currentLocation = await _location.getLocation();
    LatLng latLng =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    return latLng;
  }

  setLocation(LatLng position, bool start) {
    if (start) {
      setState(() {
        _startPoint = GeoFirePoint(position.latitude, position.longitude);
      });
    } else {
      setState(() {
        _endPoint = GeoFirePoint(position.latitude, position.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
      ),
      body: FutureBuilder<LatLng>(
          future: getMyLocation(),
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
                  // markers: {
                  //   _startPoint != null
                  //       ? Marker(
                  //           markerId: MarkerId('start'),
                  //           position: LatLng(_startPoint!.latitude,
                  //               _startPoint!.longitude),
                  //           icon: BitmapDescriptor.defaultMarker,
                  //         )
                  //       : {},
                  //   _endPoint != null
                  //       ? Marker(
                  //           markerId: MarkerId('end'),
                  //           position: LatLng(_endPoint!.latitude,
                  //               _endPoint!.longitude),
                  //           icon: BitmapDescriptor.defaultMarker,
                  //         )
                  //       : Marker(),
                  // },
                  // },
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data!,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (LatLng position) =>
                      setLocation(position, _selectingStartPosition),
                ),

                Positioned(
                  bottom: 15,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _responsive.getWidth(0.05)),
                    child: Column(
                      children: <Widget>[
                        //  select position input
                        // Container(
                        //     width: _responsive.getWidth(0.9),
                        //     padding: const EdgeInsets.all(10.0),
                        //     decoration: BoxDecoration(
                        //       color: mainColor,
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: <Widget>[
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children:  <Widget>[
                        //             GestureDetector(
                        //               onTap: (){
                        //                 setState(() {
                        //                   _selectingStartPosition = true;
                        //                 });
                        //               },
                        //               child: const Text("Enter your pickup location",
                        //                   style: TextStyle(
                        //                       color: Colors.white, fontSize: 18)),
                        //             ),
                        //           const  SizedBox(height: 10),
                        //           const  Text("Selected location",
                        //                 style: TextStyle(
                        //                     color: Colors.white, fontSize: 14)),
                        //           ],
                        //         )
                        //       ],
                        //     )),
                        // const SizedBox(height: 10),
                        //  select end position
                        Container(
                            width: _responsive.getWidth(0.9),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(2.0),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.circle,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectingStartPosition =
                                                      true;
                                                });
                                              },
                                              child: const Text(
                                                "Pickup location",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Text(
                                                _startPoint == null
                                                    ? "Select location"
                                                    : "${_startPoint?.latitude}",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.circle,
                                        color: Colors.green,
                                        size: _selectingStartPosition ? 20 : 0),
                                  ],
                                ),
                                SizedBox(height: _responsive.getHeight(.05)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(1.0),
                                          decoration: const BoxDecoration(
                                            // color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.place,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectingStartPosition =
                                                      false;
                                                });
                                              },
                                              child: const Text(
                                                "Destination location",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Text(
                                                _endPoint == null
                                                    ? "Select location"
                                                    : "${_endPoint?.latitude}",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.circle,
                                        color: Colors.green,
                                        size:
                                            !_selectingStartPosition ? 20 : 0),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),

                        // continue button
                        Container(
                          width: _responsive.getWidth(0.9),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: _responsive.getWidth(0.55),
                            // alignment: Alignment.,
                            child: Row(
                              // mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text(
                                  'Confirm',
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
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
