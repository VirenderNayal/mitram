import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required Uint8List file,
  }) async {
    String res = "error by user [empty fields]";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // register user
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        // Add user details to firestore
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'username': username,
          'email': email,
          'fullName': fullName,
          'bio': "",
          'wordsAboutJNV': "",
          'followers': [],
          'following': [],
        });

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
