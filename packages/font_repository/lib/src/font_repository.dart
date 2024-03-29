import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class FontRepository {
  final FileSystem _fileSystem;
  final FilePicker _picker;
  final List<String> _cachedFonts;

  FontRepository({
    FileSystem? fileSystem,
    FilePicker? picker,
    @visibleForTesting List<String>? cachedFonts,
  })  : _fileSystem = fileSystem ?? const LocalFileSystem(),
        _picker = picker ?? FilePicker.platform,
        _cachedFonts = cachedFonts ?? [];

  Future<String> pickFont() async {
    final result = await _picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ttf', 'otf'],
    );
    if (result != null) {
      return addFont(filePath: result.files.single.path ?? 'unexpected');
    } else {
      // User canceled the picker
      return '';
    }
  }

  @visibleForTesting
  Future<String> addFont({required String filePath}) async {
    final filename = p.basename(filePath);
    if (_cachedFonts.contains(filename)) return filename;

    File file = _fileSystem.file(filePath);
    Uint8List list = await file.readAsBytes();
    final fontLoader = FontLoader(filename);

    fontLoader.addFont(
      Future.sync(
        () {
          return ByteData.view(list.buffer);
        },
      ),
    );
    await fontLoader.load();

    _cachedFonts.add(filename);
    return filename;
  }
}
