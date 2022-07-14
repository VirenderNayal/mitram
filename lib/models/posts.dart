import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String postId;
  final String description;
  final datePublished;
  final String postPhotoUrl;
  final likes;

  const Post({
    required this.uid,
    required this.username,
    required this.postId,
    required this.description,
    required this.datePublished,
    required this.postPhotoUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "postId": postId,
      "description": description,
      "datePublished": datePublished,
      "postPhotoUrl": postPhotoUrl,
      "likes": likes,
    };
  }

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      description: snapshot['description'],
      datePublished: snapshot['datePublished'],
      postPhotoUrl: snapshot['postPhotoUrl'],
      likes: snapshot['likes'],
    );
  }
}
