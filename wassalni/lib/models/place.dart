import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class Place {
  final String label;
  final String country;
  final GeoPoint location;
  final String state;
  final String? formated_adress;
  const Place({
    required this.label,
    required this.country,
    required this.location,
    required this.state,
    this.formated_adress,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        label: json['placeLabel'] ?? json['addressLabel'] ?? '',
        country: json['country'] ?? '',
        location: GeoPoint(
          json['latitude'],
          json['longitude'],
        ),
        state: json['state'] ?? '',
        formated_adress: json['formattedAddress'] ?? '');
  }
}
