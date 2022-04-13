import 'dart:ui';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;

class ImageRepository {
  final FileSystem _fileSystem;

  ImageRepository({
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();

  PictureRecorder get recorder => PictureRecorder();

  Future<String> createImageDir() async {
    Directory directory = _fileSystem.directory(
      p.join(
        'results',
      ),
    );
    await directory.create(recursive: true);
    return directory.absolute.path;
  }

  Future<void> saveImage({
    required String filename,
    required int width,
    required int height,
    required PictureRecorder recorder,
  }) async {
    final currentRecorder = recorder;
    Image image = await currentRecorder.endRecording().toImage(width, height);
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    if (pngBytes == null) return; // Throw exception

    File createdFile = await _fileSystem
        .file(
          p.join(
            'results',
            filename + '.png',
          ),
        )
        .create(recursive: true);
    await createdFile.writeAsBytes(pngBytes.buffer.asInt8List());
  }
}
