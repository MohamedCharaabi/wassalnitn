import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:wassalni/modelView/user_crud.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:provider/provider.dart';

class FirebaseCrud extends UserCrud {
  final geo = Geoflutterfire();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userUid;
  FirebaseCrud({this.userUid}) : super();

// CollectionReference userRef = tore.collection('users');

  @override
  Future<void> createUser(Map<String, dynamic> data) {
    return firestore.collection('users').add(data);
  }

  @override
  Future<void> updateUser(Map<String, dynamic> data) {
    try {
      return firestore.collection('users').doc(data['id']).update(data);
    } catch (e) {
      // return null;
      throw e;
    }
  }

  @override
  Future<void> deleteUser(String id) {
    try {
      return firestore.collection('users').doc(id).delete();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc, doc.id);
      }).toList();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateLocation(GeoFirePoint newPosition, String userUid) async {
    try {
      await _firestore.collection('users').doc(userUid).update({
        'position': newPosition.data,
      });
      log("posidion updated");
      return null;
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> getUserInfo(String id) {
    return firestore.collection('users').doc(id).get().then((value) {
      log('message: ${value.data}');
      if (value == null) return null;
      return UserModel.fromMap(value, value.id);
    });
  }
}
