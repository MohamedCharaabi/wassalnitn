import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:wassalni/models/ride_model.dart';

class RideCrud {
  final geo = Geoflutterfire();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future addRequest(RideModel ride_model) async {
    try {
      await _firestore
          .collection('rides')
          .doc(ride_model.user_id)
          .set(ride_model.toJson());

      Fluttertoast.showToast(msg: "Request Sent");
    } catch (e) {
      // print(e.toString());
      Fluttertoast.showToast(msg: "${e}");
    }
  }

  Future<QuerySnapshot> getRides() async {
    return await _firestore.collection('rides').get();
  }

  Future cancelRide(String rideId) async {
    try {
      await _firestore.collection('rides').doc(rideId).delete();
      Fluttertoast.showToast(msg: "Request Canceled");
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.code}");
      FirebaseException(plugin: '', code: '', message: '');
      // switch(e.code) {

      // }
    }
  }
}
