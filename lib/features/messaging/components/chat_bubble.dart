import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/components/bubble_background.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isOwner;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.8,
      child: Align(
        alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment:
                isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BubbleBackground(
                  colors: isOwner
                      ? [Colors.green.shade300, Colors.green.shade800]
                      : [Colors.blue.shade300, Colors.blue.shade800],
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 15.0, color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
