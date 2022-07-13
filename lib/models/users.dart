import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String fullName;
  final String profilePicUrl;
  final List followers;
  final List following;

  const User({
    required this.uid,
    required this.username,
    required this.email,
    required this.fullName,
    required this.bio,
    required this.profilePicUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "fullName": fullName,
      "bio": bio,
      "profilePicUrl": profilePicUrl,
      "followers": followers,
      "following": following,
    };
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      fullName: snapshot['fullName'],
      profilePicUrl: snapshot['profilePicUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
