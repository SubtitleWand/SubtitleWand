import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart' hide Image;
// import 'package:flutter/rendering.dart';
import 'package:subtitle_wand/pages/app.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}