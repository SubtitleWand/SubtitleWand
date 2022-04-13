import 'package:flutter/material.dart';

class SubtitlePanelScrollController extends ValueNotifier<double> {
  SubtitlePanelScrollController(double value) : super(value);

  double get offset => value;

  set offset(double offset) {
    value = offset;
  }
}

class SubtitlePanelMoveController extends ValueNotifier<Offset> {
  SubtitlePanelMoveController(Offset value) : super(value);

  Offset get offset => value;

  set offset(Offset offset) {
    value = offset;
  }
}