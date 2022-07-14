import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mitram/models/posts.dart';
import 'package:mitram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post function
  Future<String> uploadPost(
      Uint8List file, String description, String uid, String username) async {
    String res = "ERROR";

    try {
      String postPhotoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        uid: uid,
        username: username,
        postId: postId,
        description: description,
        datePublished: DateTime.now(),
        postPhotoUrl: postPhotoUrl,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
