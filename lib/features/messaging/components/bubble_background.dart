import 'package:flutter/material.dart';
import 'package:pixify/features/messaging/components/bubble_painter.dart';

class BubbleBackground extends StatelessWidget {
  final List<Color> colors;
  final Widget? child;

  const BubbleBackground({
    super.key,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        bubbleContext: context,
        colors: colors,
        scrollable: Scrollable.of(context),
      ),
      child: child,
    );
  }
}
