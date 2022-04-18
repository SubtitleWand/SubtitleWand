import 'package:file/file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:srt_repository/src/srt_repository.dart';
import 'package:wand_api/wand_api.dart';

class MockFilePicker extends Mock implements FilePicker {}

class MockFilePickerResult extends Mock implements FilePickerResult {}

class MockPlatformFile extends Mock implements PlatformFile {}

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

void main() {
  late FilePicker picker;
  late FileSystem fileSystem;
  late SrtRepository repository;

  setUpAll(() {
    registerFallbackValue(FileType.custom);
  });

  setUp(() {
    picker = MockFilePicker();
    fileSystem = MockFileSystem();
    repository = SrtRepository(
      fileSystem: fileSystem,
      picker: picker,
    );
  });

  group('SrtRepository', () {
    group('pickSrt', () {
      test('throws exception when filepicker throws', () async {
        when(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).thenThrow(Exception());
        await expectLater(repository.pickSrt(), throwsException);

        final captured = verify(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).captured;
        expect(captured, [
          FileType.custom,
          ['srt'],
        ]);
      });

      test('returns empty when cancel picking', () async {
        when(
          () => picker.pickFiles(
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
          ),
        ).thenAnswer((_) async => null);

        expect(await repository.pickSrt(), isEmpty);
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
          await repository.pickSrt();
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
          await repository.pickSrt();
        } catch (_) {}

        verify(() => fileSystem.file('Hi')).called(1);
      });
    });

    group('getSrtDatas', () {
      const filePath = 'bbb/anypath.srt';
      test('returns empty when not existed', () async {
        final File mockFile = MockFile();

        when(() => fileSystem.file(any())).thenReturn(mockFile);
        when(() => mockFile.exists()).thenAnswer((_) async => false);

        expect(
          await repository.getSrtDatas(filePath: filePath),
          [],
        );
      });
      test('throws exception when reading error', () async {
        final File mockFile = MockFile();

        when(() => fileSystem.file(any())).thenReturn(mockFile);
        when(() => mockFile.exists()).thenAnswer((_) async => true);
        when(() => mockFile.readAsString()).thenThrow(Exception());

        await expectLater(
          repository.getSrtDatas(filePath: filePath),
          throwsException,
        );
      });

      test('returns nothing when the file is not a valid srt format', () async {
        final File mockFile = MockFile();

        when(() => fileSystem.file(any())).thenReturn(mockFile);
        when(() => mockFile.exists()).thenAnswer((_) async => true);
        when(() => mockFile.readAsString()).thenAnswer(
          (_) async => r'''1
00:00:02,719 --> 00:00:05,813a
Are you st''',
        );

        expect(
          await repository.getSrtDatas(filePath: filePath),
          [],
        );
      });

      test('returns timetext for valid srt', () async {
        final File mockFile = MockFile();

        when(() => fileSystem.file(any())).thenReturn(mockFile);
        when(() => mockFile.exists()).thenAnswer((_) async => true);
        when(() => mockFile.readAsString()).thenAnswer((_) async => srtRaw);

        await expectLater(
          repository.getSrtDatas(filePath: filePath),
          completion([
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
          ]),
        );
      });
    });
  });
}

const srtRaw = r'''1
00:00:02,719 --> 00:00:05,813
Are you still using the traditional terminal?

2
00:00:06,266 --> 00:00:09,109
Let me introduce you MinecraftCube

3
00:00:10,432 --> 00:00:12,447
You might want to take a look at my animation

4
00:00:12,548 --> 00:00:14,657
made for MinecraftCube

5
00:00:14,767 --> 00:00:17,042
No relation to the app, tho

6
00:00:18,252 --> 00:00:21,377
This demo will not cover all details


''';
