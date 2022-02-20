import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wassalni/modelView/auth_base.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/modelView/user_crud.dart';
import 'package:wassalni/models/user_model.dart';

class AuthenticationService extends AuthBase {
  final FirebaseCrud _firebaseCrud = FirebaseCrud();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<User?> currentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<String?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // credentials
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // authenticate with firebase
      final UserCredential? authResult =
          await _firebaseAuth.signInWithCredential(credential);

      // check user saved in firestore
      final User? user = authResult?.user;
      final UserModel? userExist =
          user != null ? await _checkUser(user.uid) : null;
      if (userExist == null) {
        // create user in firestore
        final UserModel userModel = UserModel(
          name: user!.displayName,
          email: user.email,
          image: user.photoURL,
          uid: user.uid,
          isDriver: true,
        );
        await FirebaseCrud().createUser(userModel.toJson());
      }

      if (authResult != null) return '${authResult.user!.uid}';
      return null;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  @override
  Future<String> googleSignUp() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // credentials
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // authenticate with firebase
      // final UserCredential authResult =
      //     await _firebaseAuth.signInWithCredential(credential);

      final UserModel newUser = UserModel(
        email: googleUser?.email,
        name: googleUser?.displayName,
        image: googleUser?.photoUrl,
        uid: googleUser?.id,
      );
      // save credentials to firestore
      await _usersCollection.add(newUser.toJson());

      return 'sucess';
    } catch (e) {
      return 'fail';
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserModel?> _checkUser(String uid) async {
    final QuerySnapshot result =
        await _usersCollection.where('uid', isEqualTo: uid).get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      return null;
    }
    return UserModel.fromMap(documents[0], documents[0].id);
  }

  @override
  Future<UserModel?> emailPassSignIn(String email, String password) async {
    try {
      final UserCredential? _user = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (_user != null) {
// get User info
        final UserModel? _connecteUserInfo =
            await _firebaseCrud.getUserInfo(_user.user!.uid);

        return _connecteUserInfo;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<String> emailPassSignUp(
      String username, String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential != null) {
        final UserModel newUser = UserModel(
          name: username,
          email: email,
          image: '',
          isDriver: true,
          uid: credential.user!.uid,
        );
        await _usersCollection.doc(credential.user!.uid).set(newUser.toJson());
        return 'sucess';
      }

      // await _firebaseCrud.createUser(UserModel(
      //   name: username,
      //   email: email,
      //   password: password,
      // ).toJson());

      return 'success';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
