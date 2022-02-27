import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:wassalni/models/ride_model.dart';

class DriverCrud {
  final geo = Geoflutterfire();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RideModel>?> getDriverRides(String driverId) async {
    try {
      QuerySnapshot _myRides = await _firestore
          .collection('rides')
          .where('driver_id', isEqualTo: driverId)
          .get();

      List<RideModel> _rides = _myRides.docs.map((doc) {
        return RideModel.fromDocument(doc);
      }).toList();

      return _rides;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<RideModel>?> getDriverRidesByStatus(
      String driverId, String status) async {
    try {
      QuerySnapshot _myRides = await _firestore
          .collection('rides')
          .where('driver_id', isEqualTo: driverId)
          .where('status', isEqualTo: status)
          .get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<RideModel>?> getDriverRidesByStatusAndDate(
      String driverId, String status, DateTime date) async {
    try {
      QuerySnapshot _myRides = await _firestore
          .collection('rides')
          .where('driver_id', isEqualTo: driverId)
          .where('status', isEqualTo: status)
          .where('date', isEqualTo: date)
          .get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<RideModel>?> getDriverRidesByStatusAndDateAndTime(
      String driverId, String status, DateTime date, DateTime time) async {
    try {
      QuerySnapshot _myRides = await _firestore
          .collection('rides')
          .where('driver_id', isEqualTo: driverId)
          .where('status', isEqualTo: status)
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<RideModel>?> getDriverHistory(String driverId) async {
    try {
      QuerySnapshot _rides = await _firestore
          .collection('rides')
          .where('drider_id', isEqualTo: driverId)
          .where("status", isEqualTo: "COMPLETED")
          .get();

      return _rides.docs.map((doc) {
        return RideModel.fromDocument(doc);
      }).toList();
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<RideModel>?> getRiderHistory(String riderId) async {
    try {
      QuerySnapshot _rides = await _firestore
          .collection('rides')
          .where('user_id', isEqualTo: riderId)
          .where("status", isEqualTo: "COMPLETED")
          .get();

      return _rides.docs.map((doc) {
        return RideModel.fromDocument(doc);
      }).toList();
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
