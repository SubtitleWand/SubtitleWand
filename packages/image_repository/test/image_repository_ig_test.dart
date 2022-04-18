@Tags(['integration'])

import 'dart:ui';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_repository/image_repository.dart';
import 'package:test_utilities/test_utilities.dart';
import 'package:path/path.dart' as p;

void main() {
  late FileSystem fileSystem;
  late ImageRepository repository;

  setUp(() {
    fileSystem = const LocalFileSystem();
    repository = ImageRepository(fileSystem: fileSystem);
  });

  group('ImageRepository', () {
    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(ImageRepository(), isNotNull);
      });
    });

    final rootPath =
        TestUtilities().getTestProjectDir(name: 'image_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });

    group('createImageDir', () {
      test('returns absolute path and create folder ', () {
        expect(
          repository.createImageDir(),
          completion(p.join(rootPath.absolute.path, 'results')),
        );
      });
    });

    group('saveImage', () {
      test('saves file from pictureRecorder', () async {
        PictureRecorder recorder = PictureRecorder();
        Canvas canvas = Canvas(recorder);
        canvas.drawCircle(Offset.zero, 3, Paint());
        await expectLater(
          repository.saveImage(
            filename: 'TEST',
            width: 10,
            height: 10,
            recorder: recorder,
          ),
          completes,
        );

        expect(
          await io.File(p.join(rootPath.path, 'results', 'TEST.png')).exists(),
          isTrue,
        );
      });
    });
  });
}
