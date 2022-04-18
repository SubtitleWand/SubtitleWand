@Tags(['integration'])

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:srt_repository/src/srt_repository.dart';
import 'package:test_utilities/test_utilities.dart';
import 'package:wand_api/wand_api.dart';

void main() {
  late SrtRepository repository;
  late FileSystem fileSystem;
  setUp(() {
    fileSystem = const LocalFileSystem();
    repository = SrtRepository(
      fileSystem: fileSystem,
      picker: FilePicker.platform,
    );
  });

  group('SrtRepository', () {
    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(SrtRepository(), isNotNull);
      });
    });

    group('getSrtDatas', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'font_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test('returns empty with empty file', () async {
        expect(
          await repository.getSrtDatas(
            filePath: '',
          ),
          [],
        );
      });

      test('returns correct srt', () async {
        const basename = 'test.srt';
        await copyPath(
          p.join(TestUtilities().rootResources, 'srt'),
          p.join(rootPath.path),
        );

        expect(
          await repository.getSrtDatas(
            filePath: p.join(rootPath.path, basename),
          ),
          [
            TimeText(
              text: 'Are you still using the traditional terminal?',
              startTimestamp:
                  DateTime.fromMillisecondsSinceEpoch(2 * 1000 + 719),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(5 * 1000 + 813),
            ),
            TimeText(
              text: 'Let me introduce you MinecraftCube',
              startTimestamp:
                  DateTime.fromMillisecondsSinceEpoch(6 * 1000 + 266),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(9 * 1000 + 109),
            ),
            TimeText(
              text: 'You might want to take a look at my animation',
              startTimestamp:
                  DateTime.fromMillisecondsSinceEpoch(10 * 1000 + 432),
              endTimeStamp:
                  DateTime.fromMillisecondsSinceEpoch(12 * 1000 + 447),
            ),
            TimeText(
              text: 'made for MinecraftCube',
              startTimestamp:
                  DateTime.fromMillisecondsSinceEpoch(12 * 1000 + 548),
              endTimeStamp:
                  DateTime.fromMillisecondsSinceEpoch(14 * 1000 + 657),
            ),
            TimeText(
              text: 'No relation to the app, tho',
              startTimestamp:
                  DateTime.fromMillisecondsSinceEpoch(14 * 1000 + 767),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(17 * 1000 + 42),
            ),
            TimeText(
              text: 'This demo will not cover all details',
              startTimestamp:
                  DateTime.fromMillisecondsSinceEpoch(18 * 1000 + 252),
              endTimeStamp:
                  DateTime.fromMillisecondsSinceEpoch(21 * 1000 + 377),
            ),
          ],
        );
      });
    });
  });
}
