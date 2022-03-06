import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:wassalni/models/enums.dart';

class RideModel {
  String user_id;
  String driver_id;
  GeoFirePoint? start;
  GeoFirePoint? destination;
  Timestamp? time;
  double? price;
  RideStatus status;

  RideModel(
      {required this.user_id,
      required this.driver_id,
      this.start,
      this.destination,
      this.price,
      this.time,
      this.status = RideStatus.REQUESTED});

  factory RideModel.fromDocument(Map<String, dynamic> map) {
    final GeoPoint? start =
        map['start'] != null ? map['start']['geopoint'] as GeoPoint : null;

    final GeoPoint? destination = map['destination'] != null
        ? map['destination']['geopoint'] as GeoPoint
        : null;

    return RideModel(
      user_id: map['user_id'],
      driver_id: map['driver_id'],
      start:
          start != null ? GeoFirePoint(start.latitude, start.longitude) : null,
      destination: destination != null
          ? GeoFirePoint(destination.latitude, destination.longitude)
          : null,
      price: map['price'] != null ? map['price'] : null,
      time: map['time'] != null ? map['time'] : null,
      status: RideStatus.REQUESTED,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'driver_id': driver_id,
      'start': start!.data,
      'destination': destination!.data,
      'price': price,
      'time': time,
      'status': status.name,
    };
  }
}
