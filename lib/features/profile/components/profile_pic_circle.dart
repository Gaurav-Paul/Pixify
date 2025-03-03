import 'package:flutter/material.dart';

class ProfilePicCircle extends StatelessWidget {
  final String profilePicURL;
  const ProfilePicCircle({
    super.key,
    required this.profilePicURL,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          barrierColor: Colors.white54,
          opaque: false,
          pageBuilder: (context, _, __) => Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: InteractiveViewer(
                      child: Image.network(
                        profilePicURL,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress != null
                                ? Center(
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.width,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  )
                                : child,
                      ),
                    ),
                  ),
                  IconButton(
                    style:
                        IconButton.styleFrom(backgroundColor: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.amber,
        radius: 25,
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.black,
          foregroundImage: NetworkImage(profilePicURL),
        ),
      ),
    );
  }
}
