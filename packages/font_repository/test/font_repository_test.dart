import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_repository/font_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFilePicker extends Mock implements FilePicker {}

class MockFilePickerResult extends Mock implements FilePickerResult {}

class MockPlatformFile extends Mock implements PlatformFile {}

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

void main() {
  late FilePicker picker;
  late FileSystem fileSystem;
  late FontRepository repository;

  setUpAll(() {
    registerFallbackValue(FileType.custom);
  });

  setUp(() {
    picker = MockFilePicker();
    fileSystem = MockFileSystem();
    repository = FontRepository(
      fileSystem: fileSystem,
      picker: picker,
    );
  });

  group('FFmpegRepository', () {
    group('pickFont', () {
      test('throws exception when filepicker throws', () async {
        when(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).thenThrow(Exception());
        await expectLater(repository.pickFont(), throwsException);

        final captured = verify(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).captured;
        expect(captured, [
          FileType.custom,
          ['ttf', 'otf'],
        ]);
      });

      test('returns empty when cancel picking', () async {
        when(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).thenAnswer((_) async => null);

        expect(await repository.pickFont(), '');
      });

      test('calls addFont after picking a file (with null path)', () async {
        FilePickerResult result = MockFilePickerResult();
        PlatformFile platformFile = MockPlatformFile();
        when(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).thenAnswer((_) async => result);
        when(() => platformFile.path).thenReturn(null);
        when(() => result.files).thenReturn([platformFile]);
        try {
          await repository.pickFont();
        } catch (_) {}

        verify(() => fileSystem.file('unexpected')).called(1);
      });

      test('calls addFont after picking a file (with normal path)', () async {
        FilePickerResult result = MockFilePickerResult();
        PlatformFile platformFile = MockPlatformFile();
        when(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).thenAnswer((_) async => result);
        when(() => platformFile.path).thenReturn('Hi');
        when(() => result.files).thenReturn([platformFile]);
        try {
          await repository.pickFont();
        } catch (_) {}

        verify(() => fileSystem.file('Hi')).called(1);
      });
    });

    group('addFont', () {
      const filePath = 'bbb/anypath.ttf';

      test('returns existed font name without doing hard job', () async {
        repository = FontRepository(
          picker: picker,
          fileSystem: fileSystem,
          cachedFonts: ['anypath.ttf'],
        );

        expect(await repository.addFont(filePath: filePath), 'anypath.ttf');

        verifyNever(() => fileSystem.file(any()));
      });

      test('throws exception when reading error or unexisted', () async {
        final List<String> caches = [];
        repository = FontRepository(
          picker: picker,
          fileSystem: fileSystem,
          cachedFonts: caches,
        );

        final File mockFile = MockFile();

        when(() => fileSystem.file(any())).thenReturn(mockFile);
        when(() => mockFile.readAsBytes()).thenThrow(Exception());

        await expectLater(
          repository.addFont(filePath: filePath),
          throwsException,
        );
      });

      test('returns basename for the path', () async {
        final List<String> caches = [];
        repository = FontRepository(
          picker: picker,
          fileSystem: fileSystem,
          cachedFonts: caches,
        );

        final File mockFile = MockFile();

        when(() => fileSystem.file(any())).thenReturn(mockFile);
        when(() => mockFile.readAsBytes())
            .thenAnswer((_) async => Uint8List(10));

        await expectLater(
          repository.addFont(filePath: filePath),
          completion('anypath.ttf'),
        );
        expect(caches.length, equals(1));
      });
    });
  });
}
