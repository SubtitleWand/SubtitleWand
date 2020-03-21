import 'dart:ui';

import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {

  final TextPainter textPainter;
  MyCustomPainter(this.textPainter);

  @override
  void paint(Canvas canvas, Size size) {
    textPainter.layout();
    textPainter.paint(canvas, new Offset(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    MyCustomPainter painter = oldDelegate as MyCustomPainter;
    return painter.textPainter.text != textPainter.text;
  }

}