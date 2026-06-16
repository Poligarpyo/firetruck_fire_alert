
import 'package:flutter/material.dart';

// ignore: unused_element
class LinePainter extends CustomPainter {
  late final Color color;
  late final bool dashed;

  LinePainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    if (!dashed) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    } else {
      const dashWidth = 5.0;
      const gapWidth = 3.0;
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, size.height / 2),
          Offset((x + dashWidth).clamp(0, size.width), size.height / 2),
          paint,
        );
        x += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(LinePainter old) =>
      old.color != color || old.dashed != dashed;
}