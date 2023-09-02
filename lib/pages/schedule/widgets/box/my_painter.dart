import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Color.fromARGB(80, 10, 10, 10)
    ..strokeWidth = 3;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTRB(
          size.width * 0.82,
          size.height - size.width * 0.18,
          size.width,
          size.height,
        ),
        _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
