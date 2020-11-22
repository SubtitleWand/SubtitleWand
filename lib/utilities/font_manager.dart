import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

///
/// Manage fonts in memory, use flutter's FontLoader, so It could be used anywhere with the [familyName]
///
class FontManager {
  final Map<String, FontLoader> _fonts;
  FontManager() :
    _fonts = <String, FontLoader>{};

  ///
  /// Assign [fontFamilyName] to flutter's FontLoader, with [pathToTTF] from file system.
  ///
  Future<void> addFont(String fontFamilyName, String pathToTTF) async {
    File file;
    try {
      file = File('$pathToTTF');
    } catch(err) {
      // throw err;
      rethrow;
    }
    Uint8List list = await file.readAsBytes();
    _fonts[fontFamilyName] = FontLoader(fontFamilyName);
    _fonts[fontFamilyName].addFont(Future.sync(() {
      return ByteData.view(list.buffer);
    }));
    await _fonts[fontFamilyName].load();
  }

  ///
  /// check If familyName is already used
  ///
  bool contains(String fontFamilyName) {
    return _fonts.containsKey(fontFamilyName);
  }
}