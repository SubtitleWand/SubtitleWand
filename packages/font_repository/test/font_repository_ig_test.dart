@Tags(['integration'])

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_repository/font_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

void main() {
  late FontRepository repository;
  late FileSystem fileSystem;
  late List<String> cacheFonts;
  setUp(() {
    fileSystem = const LocalFileSystem();
    cacheFonts = [];
    repository = FontRepository(
      fileSystem: fileSystem,
      picker: FilePicker.platform,
      cachedFonts: cacheFonts,
    );
  });

  group('FontRepository', () {
    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(FontRepository(), isNotNull);
      });
    });

    group('addFont', () {
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

      test('throws exception with empty file', () async {
        expect(
          repository.addFont(
            filePath: '',
          ),
          throwsException,
        );
      });
      test('returns basename even It\'s not .ttf/.otf', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'wrong_file'),
          p.join(rootPath.path),
        );

        expect(
          repository.addFont(
            filePath: p.join(rootPath.path, 'abc.ggp'),
          ),
          completion('abc.ggp'),
        );
      });

      test('returns basename', () async {
        const basename = 'Roboto-Regular.ttf';
        await copyPath(
          p.join(TestUtilities().rootResources, 'normal_file'),
          p.join(rootPath.path),
        );

        expect(cacheFonts, isEmpty);

        expect(
          await repository.addFont(
            filePath: p.join(rootPath.path, basename),
          ),
          basename,
        );
        expect(cacheFonts.length, equals(1));
      });

      test('returns basename when adding twice', () async {
        const basename = 'Roboto-Regular.ttf';
        await copyPath(
          p.join(TestUtilities().rootResources, 'normal_file'),
          p.join(rootPath.path),
        );

        expect(cacheFonts, isEmpty);
        expect(
          await repository.addFont(
            filePath: p.join(rootPath.path, basename),
          ),
          basename,
        );
        expect(cacheFonts.length, equals(1));

        expect(
          await repository.addFont(
            filePath: p.join(rootPath.path, basename),
          ),
          basename,
        );
        expect(cacheFonts.length, equals(1));
      });
    });
  });
}
