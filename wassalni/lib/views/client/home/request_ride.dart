import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wassalni/main.dart';
import 'package:wassalni/modelView/services/location_service.dart';
import 'package:wassalni/models/place.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:location/location.dart' as Loc;
import 'package:wassalni/utils/styles.dart';
import 'package:wassalni/views/client/home/ride_destination_screen.dart';

class RideStartScreen extends StatefulWidget {
  const RideStartScreen({Key? key}) : super(key: key);

  @override
  _RideStartScreenState createState() => _RideStartScreenState();
}

class _RideStartScreenState extends State<RideStartScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  bool _openSearch = false;
  String _searchAddress = '';

  // bool _selectingStartPosition = true;
  GeoFirePoint? _startPoint;
  // GeoFirePoint? _endPoint;
// markers
  Set<Marker> _markers = {};
  setLocation(LatLng position) {
    setState(() {
      _startPoint = GeoFirePoint(position.latitude, position.longitude);
      if (_markers.isNotEmpty) {
        // empty the markers
        _markers.clear();
        _markers.add(Marker(
            markerId: const MarkerId('start'),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet)));
      } else {
        _markers.add(Marker(
            markerId: const MarkerId('start'),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet)));
      }
    });
  }

  LocationService _locationService = LocationService();
  List<Place>? _searchPlaces = [];
  bool _searchLoading = false;
  Place? _selectedAdress;
  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Start Location"),
        centerTitle: true,
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
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data!,
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (LatLng position) => setLocation(position)),

// search adress Input
                Positioned(
                  top: 15.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _responsive.getWidth(0.05)),
                    child: Column(
                      children: [
                        Container(
                          width: _responsive.getWidth(.9),
                          padding: EdgeInsets.symmetric(
                              horizontal: _responsive.getWidth(0.05)),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: <Widget>[
                              // icon
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
                              Expanded(
                                  child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                onChanged: (value) async {
                                  setState(() {
                                    _searchAddress = value;
                                    _selectedAdress = null;
                                    _searchLoading = true;
                                  });
                                  _searchPlaces =
                                      await _locationService.getAdress(value);

                                  setState(() {
                                    _searchLoading = false;
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        verticalSpace(5),
                        //  search result
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: _searchAddress.isNotEmpty &&
                                  _selectedAdress == null
                              ? _responsive.getHeight(.3)
                              : 0,
                          width: _responsive.getWidth(.9),
                          padding: EdgeInsets.all(_responsive.getWidth(0.05)),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _searchLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: white,
                                ))
                              : ListView.builder(
                                  itemCount: _searchPlaces?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedAdress =
                                              _searchPlaces![index];
                                        });

                                        // change map location
                                        if (_selectedAdress != null) {}
                                        _controller.future.then((value) {
                                          value.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: LatLng(
                                                    _searchPlaces![index]
                                                        .location
                                                        .latitude,
                                                    _searchPlaces![index]
                                                        .location
                                                        .longitude),
                                                zoom: 15,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            _responsive.getResponsiveHeight(4)),
                                        margin: EdgeInsets.only(
                                            bottom: _responsive
                                                .getResponsiveHeight(3)),
                                        decoration: BoxDecoration(
                                          color: _selectedAdress ==
                                                  _searchPlaces![index]
                                              ? Colors.amber
                                              : white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.place),
                                            horizontalSpace(5),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_searchPlaces![index].label}',
                                                  style: text_bold.copyWith(
                                                      color: background),
                                                ),
                                                Text(
                                                  '${_searchPlaces![index].state}',
                                                  style: text_normal.copyWith(
                                                      color: background
                                                          .withOpacity(.5)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                ),

// bottom fields
                Positioned(
                  bottom: 15,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _responsive.getWidth(0.05)),
                    child: _searchAddress.isNotEmpty && _selectedAdress == null
                        ? const SizedBox()
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            // height: 0,
                            child: Column(
                              children: <Widget>[
                                // continue button
                                InkWell(
                                  onTap: () {
                                    log('${_markers.length}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RideDestinationScreen(
                                                    startPoint:
                                                        _markers.first)));
                                  },
                                  child: Container(
                                    width: _responsive.getWidth(0.9),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: _startPoint != null
                                          ? background
                                          : background.withOpacity(.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: _responsive.getWidth(0.55),
                                      // alignment: Alignment.,
                                      child: Row(
                                        // mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const <Widget>[
                                          Text(
                                            'Continue',
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
