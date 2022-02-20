import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:wassalni/models/user_model.dart';

abstract class UserCrud {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser(Map<String, dynamic> data);
  Future<void> updateUser(Map<String, dynamic> data);
  Future<void> deleteUser(String id);
  // Future<void> deleteUserByEmail(String email);
  Future<UserModel?> getUserInfo(String id);
  // Future<User> getUserByEmail(String email);
  Future<List<UserModel>> getUsers();

  // Future<List<UserModel>> getUsersByLocation(
  //     double latitude, double longitude, double radius);

  Future<void> updateLocation(GeoFirePoint newPosition, String userUid);
}
