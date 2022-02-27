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
  RideStatus? status;

  RideModel(
      {required this.user_id,
      required this.driver_id,
      this.start,
      this.destination,
      this.price,
      this.time,
      this.status});

  factory RideModel.fromDocument(DocumentSnapshot doc) {
    return RideModel(
      user_id: doc['user_id'],
      driver_id: doc['driver_id'],
      start: doc['start'],
      destination: doc['destination'] != null ? doc['destination'] : null,
      price: doc['price'] != null ? doc['price'] : null,
      time: doc['time'] != null ? doc['time'] : null,
      status: doc['status'] != null ? doc['status'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'driver_id': driver_id,
      'start': start,
      'destination': destination,
      'price': price,
      'time': time,
      'status': status,
    };
  }
}
