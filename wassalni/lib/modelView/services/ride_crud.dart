import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:wassalni/models/ride_model.dart';

class RideCrud {
  // final geo = Geoflutterfire();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addRequest(RideModel ride_model) async {
    try {
      await _firestore
          .collection('rides')
          .doc(ride_model.user_id)
          .set(ride_model.toJson());

      Fluttertoast.showToast(msg: "Request Sent");
      return true;
    } catch (e) {
      // print(e.toString());
      Fluttertoast.showToast(msg: "${e}");
      return false;
    }
  }

  Future<List<RideModel>?> getUserRides(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('rides')
          .where('user_id', isEqualTo: userId)
          .get();

      List<RideModel> ride_models = querySnapshot.docs
          .map((doc) =>
              RideModel.fromDocument(doc.data() as Map<String, dynamic>))
          .toList();

      return ride_models;
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
