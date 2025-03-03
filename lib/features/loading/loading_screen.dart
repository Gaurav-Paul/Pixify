import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String loadingText;
  const LoadingScreen({
    super.key,
    required this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  'assets/oia-uia.gif',
                ),
              ),
            ),
            const SizedBox(height: 200),
            Text(
              loadingText,
              style: const TextStyle(fontSize: 18, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
