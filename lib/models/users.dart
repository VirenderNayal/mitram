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
}
