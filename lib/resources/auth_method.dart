import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mitram/models/users.dart' as model;
import 'package:mitram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // function to sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String fullName,
    String bio = "",
    required Uint8List? file,
  }) async {
    String res = "error by user [empty fields]";
    String profilePicUrl = "";

    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        // register user
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        if (file != null) {
          profilePicUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        }

        // Add user details to firestore
        model.User user = model.User(
          uid: userCredential.user!.uid,
          username: username,
          bio: bio,
          email: email,
          fullName: fullName,
          profilePicUrl: profilePicUrl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // function to login the user
  // TODO : add functionallity to login using username
  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = "error";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
