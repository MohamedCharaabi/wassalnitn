import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wassalni/models/place.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  final loc.Location _location = loc.Location();
  Future<List<Place>?> getAdress(String term) async {
    try {
      http.Response _response = await http.get(
          Uri.parse(
              'https://api.radar.io/v1/search/autocomplete?query=$term&country=tn&limit=3'),
          headers: {
            'Authorization':
                'prj_test_pk_8531c1a80d96a5d9c199dcb6ce741bdc8444f3be',
          });

      if (_response.statusCode == 200) {
        var data = json.decode(_response.body);
        List<Place> places = [];
        for (var item in data['addresses']) {
          places.add(Place.fromJson(item));
        }
        return places;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      return null;
    }
  }

  Future<LatLng> getMyLocation() async {
    var currentLocation = await _location.getLocation();
    LatLng latLng =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    return latLng;
  }
}
