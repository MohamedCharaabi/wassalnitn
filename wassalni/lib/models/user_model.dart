import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? password;
  String? image;
  String? phone;
  String? address;
  String? city;
  String? state;
  bool? isDriver;
  bool? online;
  GeoFirePoint? position;

  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.password,
      this.image,
      this.phone,
      this.address,
      this.city,
      this.state,
      this.isDriver,
      this.online,
      this.position});

  factory UserModel.fromMap(DocumentSnapshot doc, String uid) {
    // log('${doc.data()}');
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: uid,
      name: map['name'],
      email: map['email'],
      password: map['password'],
      image: map['image'],
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      isDriver: map['isDriver'] ?? false,
      online: map['online'] ?? false,
      position: map['position'] != null ? GeoFirePoint(0, 0) : null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // log('${json['position']}');
    final GeoPoint? point = json['position'] != null
        ? json['position']['geopoint'] as GeoPoint
        : null;

    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      isDriver: json['isDriver'] ?? false,
      online: json['online'] ?? false,
      position:
          point != null ? GeoFirePoint(point.latitude, point.longitude) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "image": image,
      "phone": phone,
      "address": address,
      "city": city,
      "state": state,
      "online": online,
      "position": position,
      "isDriver": isDriver,
    };
  }
}
