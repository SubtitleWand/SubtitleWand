import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FontManager {
  final Map<String, FontLoader> _fonts;
  FontManager() :
    _fonts = new Map<String, FontLoader>();

  Future<void> addFont(String fontFamilyName, String pathToTTF) async {
    File file;
    try {
      file = new File("$pathToTTF");
    } catch(err) {
      print(err);
      throw err;
    }
    Uint8List list = await file.readAsBytes();
    _fonts[fontFamilyName] = new FontLoader(fontFamilyName);
    _fonts[fontFamilyName].addFont(Future.sync(() {
      return ByteData.view(list.buffer);
    }));
    await _fonts[fontFamilyName].load();
  }

  bool contains(String fontFamilyName) {
    return _fonts.containsKey(fontFamilyName);
  }
}