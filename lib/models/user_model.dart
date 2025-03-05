class UserModel {
  final String username;
  final String uid;
  final String email;
  final String profilePicURL;
  final List posts;
  final List followers;
  final List following;
  final List conversations;
  final bool active;
  final int lastSeen;
  final bool isPrivate;

  UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.profilePicURL,
    required this.posts,
    required this.followers,
    required this.following,
    required this.isPrivate,
    required this.conversations,
    required this.active,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'profilePicURL': profilePicURL,
      'posts': posts,
      'followers': followers,
      'following': following,
      'isPrivate': isPrivate,
      "active": true,
      "lastSeen": DateTime.now().microsecondsSinceEpoch,
      "conversations": conversations,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      uid: map['uid'],
      email: map['email'],
      profilePicURL: map['profilePicURL'],
      posts: map['posts'],
      followers: map['followers'],
      following: map['following'],
      isPrivate: map['isPrivate'],
      conversations: map['conversations'],
      active: map["active"],
      lastSeen: map['lastSeen'],
    );
  }
}
