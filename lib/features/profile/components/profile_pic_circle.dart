import 'package:flutter/material.dart';

class ProfilePicCircle extends StatelessWidget {
  final String profilePicURL;
  const ProfilePicCircle({
    super.key,
    required this.profilePicURL,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.amber,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.black,
        foregroundImage: NetworkImage(profilePicURL),
      ),
    );
  }
}
