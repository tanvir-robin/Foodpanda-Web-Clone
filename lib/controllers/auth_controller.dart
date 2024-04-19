import 'dart:typed_data';

import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthController extends GetxController {
  String? fullName;
  String? emailOfUser;
  String? docID;
  String? restaurantName;
  String? coverURL;
  bool? isLoggedIn;
  final memory = GetStorage();

  Future<bool> checkPreviousLogin() async {
    if (await memory.read('isLoggedIn') == true) {
      isLoggedIn = true;
      fullName = memory.read('fullName');
      docID = memory.read('docID');
      emailOfUser = memory.read('emailOfUser');
      update();
    }
    return true;
  }

  Future<UserCredential> createNewAccount(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'name': name, 'email': email});
      }
      fullName = name;
      emailOfUser = email;
      docID = userCredential.user!.uid;

      memory.write('fullName', fullName);
      memory.write('emailOfUser', emailOfUser);
      memory.write('docID', docID);
      memory.write('isLoggedIn', true);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Handle weak password error

        showToastMessage('Password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // Handle email already in use error

        showToastMessage('Email is already in use.');
      } else {
        // Handle other errors

        showToastMessage('${e.message}');
      }
      rethrow;
    }
  }

  Future<UserCredential> createNewRestaurantAccount(
      String email,
      String password,
      String name,
      String address,
      Uint8List? coverPhoto,
      LatLng? cordinate) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? coverURL;
      // String? coverURL =
      //     'https://firebasestorage.googleapis.com/v0/b/foodpanda-clone-bacba.appspot.com/o/360_F_324739203_keeq8udvv0P2h1MLYJ0GLSlTBagoXS48.jpg?alt=media&token=4ef5bd2e-4bb5-462a-a788-81254cd495a3';
      if (coverPhoto != null) {
        coverURL = uint8ListToBase64(coverPhoto);
      } else {
        print("bhai nullllll!");
      }

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'address': address,
          'coverPhoto': coverURL,
          'location_lat': cordinate?.latitude,
          'location_long': cordinate?.longitude,
        });
      }
      fullName = name;
      emailOfUser = email;
      docID = userCredential.user!.uid;

      memory.write('fullName', fullName);
      memory.write('emailOfUser', emailOfUser);
      memory.write('address', address);
      memory.write('docID', docID);
      memory.write('isLoggedIn', true);
      memory.write('cover', coverURL);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Handle weak password error

        showToastMessage('Password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // Handle email already in use error

        showToastMessage('Email is already in use.');
      } else {
        // Handle other errors

        showToastMessage('${e.message}');
      }
      rethrow;
    }
  }

  Future<UserCredential> loginUser(String email, String password) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        print('Some rn');
      }

      docID = userCredential.user!.uid;
      final response =
          await FirebaseFirestore.instance.collection('users').doc(docID).get();

      final userInfo = response.data();
      if (userInfo == null) {
        showToastMessage('No user found for that email.');
      }
      fullName = userInfo!['name'];
      emailOfUser = email;
      memory.write('fullName', fullName);
      memory.write('emailOfUser', emailOfUser);
      memory.write('docID', docID);
      memory.write('isLoggedIn', true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showToastMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showToastMessage('Wrong password provided for that user.');
      } else {
        print(e.message);
        showToastMessage('${e.message}');
      }
      rethrow; // Rethrow to allow further error handling in the calling code
    }
  }

  Future<UserCredential> loginReastaurant(String email, String password) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      docID = userCredential.user!.uid;
      final response = await FirebaseFirestore.instance
          .collection('restaurant')
          .doc(docID)
          .get();
      final userInfo = response.data();
      fullName = userInfo!['name'];
      emailOfUser = email;
      memory.write('fullName', fullName);
      memory.write('emailOfUser', emailOfUser);
      memory.write('docID', docID);
      memory.write('isLoggedIn', true);
      update();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showToastMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showToastMessage('Wrong password provided for that user.');
      } else {
        print(e.message);
        showToastMessage('${e.message}');
      }
      rethrow; // Rethrow to allow further error handling in the calling code
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await memory.write('isLoggedIn', false);
    isLoggedIn = false;
    await memory.remove('docID');
    await memory.remove('emailOfUser');
    await memory.remove('fullName');
    await memory.remove('cover');
    update();
  }
}
