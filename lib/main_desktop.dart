import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride, kReleaseMode;
import 'package:flutter/material.dart' hide Image;
// import 'package:flutter/rendering.dart';
import 'package:subtitle_wand/pages/app.dart';
import 'package:subtitle_wand/utilities/logger_util.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  // debugPaintSizeEnabled = true;
  await LoggerUtil.getInstance().configure(level: kReleaseMode ? LoggerLevel.Production : LoggerLevel.Debug);
  runApp(MyApp());
}