import 'package:flutter/material.dart';

class SubtitleCanvasScrollController extends ValueNotifier<double> {
  SubtitleCanvasScrollController(double value) : super(value);

  double get offset => value;

  set offset(double offset) {
    value = offset;
  }
}

class SubtitleCanvasMoveController extends ValueNotifier<Offset> {
  SubtitleCanvasMoveController(Offset value) : super(value);

  Offset get offset => value;

  set offset(Offset offset) {
    value = offset;
  }
}
