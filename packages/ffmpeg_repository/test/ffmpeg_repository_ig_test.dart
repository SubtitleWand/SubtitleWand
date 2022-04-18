@Tags(['integration'])
import 'dart:io' as io;
import 'package:ffmpeg_repository/ffmpeg_repository.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:process/process.dart';
import 'package:test_utilities/test_utilities.dart';
import 'package:path/path.dart' as p;
import 'package:wand_api/wand_api.dart';

void main() {
  late FFmpegRepository repository;
  late FileSystem fileSystem;
  late ProcessManager processManager;
  setUp(() {
    fileSystem = const LocalFileSystem();
    processManager = const LocalProcessManager();
    repository = FFmpegRepository(
      fileSystem: fileSystem,
      processManager: processManager,
    );
  });

  group('FFmpegRepository', () {
    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(FFmpegRepository(), isNotNull);
      });
    });

    group('isFFmpegEnvDetected', () {
      test('return true when no ffmpeg', () async {
        expect(
          await repository.isFFmpegEnvDetected(),
          isTrue,
        );
      });
    });

    group('writeFFmpegContact', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'ffmpeg_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });
      test('returns normally', () async {
        await repository.writeFFmpegContact(
          texts: [
            TimeText(
              text: 'SPECIAL_TITLE',
              startTimestamp: DateTime(2022, 1, 1, 0, 0, 49),
              endTimeStamp: DateTime(2022, 1, 1, 0, 0, 50),
            )
          ],
          directory: 'any',
        );
        expect(
          await io.File(p.join(rootPath.path, 'any', 'video.ffconcat'))
              .readAsString(),
          equals(ffcontactResult),
        );
      });
    });

    group('generateVideo', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'ffmpeg_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test('generate out.mp4', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'ffmpeg_generate_video'),
          p.join(rootPath.path),
        );
        await repository.generateVideo(directory: rootPath.path);

        expect(
          await io.File(p.join(rootPath.path, 'out.mp4')).exists(),
          isTrue,
        );
      });
    });
  });
}

const ffcontactResult = r'''ffconcat version 1.0
file transparent.png
duration 0.0
file frame_0.png
duration 1.0
file transparent.png
duration 4
''';
