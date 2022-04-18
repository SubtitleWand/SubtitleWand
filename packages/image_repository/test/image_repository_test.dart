import 'dart:ui';

import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_repository/image_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockPictureRecorder extends Mock implements PictureRecorder {}

class MockPicture extends Mock implements Picture {}

class MockImage extends Mock implements Image {}

void main() {
  late FileSystem fileSystem;
  late ImageRepository repository;

  setUpAll(() {
    registerFallbackValue(ImageByteFormat.png);
  });

  setUp(() {
    fileSystem = MockFileSystem();
    repository = ImageRepository(fileSystem: fileSystem);
  });

  group('ImageRepository', () {
    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(ImageRepository(), isNotNull);
      });
    });

    group('createImageDir', () {
      test('throws exception when creating file throws exception', () {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory('results')).thenReturn(directory);
        when(() => directory.create(recursive: true)).thenThrow(Exception());
        expect(
          repository.createImageDir(),
          throwsException,
        );
      });
      test('returns absolute path and create folder ', () {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory('results')).thenReturn(directory);
        when(() => directory.create(recursive: true))
            .thenAnswer((_) async => directory);
        when(() => directory.absolute).thenReturn(directory);
        when(() => directory.path).thenReturn('PATH_A');
        expect(
          repository.createImageDir(),
          completion('PATH_A'),
        );
      });
    });

    group('saveImage', () {
      test('returns normally when image cannot convert to png', () async {
        PictureRecorder pictureRecorder = MockPictureRecorder();
        Picture picture = MockPicture();
        Image image = MockImage();
        when(() => pictureRecorder.endRecording()).thenReturn(picture);
        when(() => picture.toImage(10, 10)).thenAnswer((_) async => image);
        when(() => image.toByteData(format: ImageByteFormat.png))
            .thenAnswer((_) async => null);
        expect(
          () => repository.saveImage(
            filename: 'anyFile',
            width: 10,
            height: 10,
            recorder: pictureRecorder,
          ),
          returnsNormally,
        );
        verifyNever(() => fileSystem.file(any()));
      });

      test('returns normally and file created', () async {
        PictureRecorder recorder = PictureRecorder();
        Canvas canvas = Canvas(recorder);
        canvas.drawCircle(Offset.zero, 3, Paint());
        File file = MockFile();
        when(
          () => fileSystem.file(
            p.join(
              'results',
              'TEST.png',
            ),
          ),
        ).thenReturn(file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsBytes(any())).thenAnswer((_) async => file);
        await expectLater(
          repository.saveImage(
            filename: 'TEST',
            width: 10,
            height: 10,
            recorder: recorder,
          ),
          completes,
        );

        verify(() => file.writeAsBytes(any())).called(1);
      });
    });
  });
}
