import 'dart:io';

import 'package:ffmpeg_repository/ffmpeg_repository.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

import 'package:path/path.dart' as p;
import 'package:wand_api/wand_api.dart';

class MockPlatform extends Mock implements Platform {}

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements ProcessResult {}

void main() {
  late FFmpegRepository repository;
  late FileSystem fileSystem;
  late ProcessManager processManager;
  late Platform platform;
  setUp(() {
    fileSystem = MockFileSystem();
    processManager = MockProcessManager();
    platform = MockPlatform();
    repository = FFmpegRepository(
      fileSystem: fileSystem,
      platform: platform,
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
      group('[windows]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(true);
        });

        test('throws exception when processManager.run fails', () async {
          when(() => processManager.run(captureAny(), runInShell: true))
              .thenThrow(Exception());
          await expectLater(
            () async => await repository.isFFmpegEnvDetected(),
            throwsException,
          );
          final captured =
              verify(() => processManager.run(captureAny(), runInShell: true))
                  .captured;
          expect(captured, [
            ['where', 'ffmpeg']
          ]);
        });

        test('return false when no ffmpeg', () async {
          final processResult = MockProcessResult();
          when(() => processManager.run(captureAny(), runInShell: true))
              .thenAnswer((_) async => processResult);
          when(() => processResult.stderr).thenReturn('');
          when(() => processResult.stdout).thenReturn('');
          when(() => processResult.exitCode).thenReturn(-1);
          expect(
            await repository.isFFmpegEnvDetected(),
            isFalse,
          );
        });

        test('return true when no ffmpeg', () async {
          final processResult = MockProcessResult();
          when(() => processManager.run(captureAny(), runInShell: true))
              .thenAnswer((_) async => processResult);
          when(() => processResult.stderr).thenReturn('');
          when(() => processResult.stdout).thenReturn('');
          when(() => processResult.exitCode).thenReturn(0);
          expect(
            await repository.isFFmpegEnvDetected(),
            isTrue,
          );
        });
      });

      group('[macos or linux]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(false);
        });

        test('throws exception when processManager.run fails', () async {
          when(() => processManager.run(captureAny(), runInShell: true))
              .thenThrow(Exception());
          await expectLater(
            () async => await repository.isFFmpegEnvDetected(),
            throwsException,
          );
          final captured =
              verify(() => processManager.run(captureAny(), runInShell: true))
                  .captured;
          expect(captured, [
            ['which', 'ffmpeg']
          ]);
        });

        test('return false when no ffmpeg', () async {
          final processResult = MockProcessResult();
          when(() => processManager.run(captureAny(), runInShell: true))
              .thenAnswer((_) async => processResult);
          when(() => processResult.stderr).thenReturn('');
          when(() => processResult.stdout).thenReturn('');
          when(() => processResult.exitCode).thenReturn(-1);
          expect(
            await repository.isFFmpegEnvDetected(),
            isFalse,
          );
        });

        test('return true when no ffmpeg', () async {
          final processResult = MockProcessResult();
          when(() => processManager.run(captureAny(), runInShell: true))
              .thenAnswer((_) async => processResult);
          when(() => processResult.stderr).thenReturn('');
          when(() => processResult.stdout).thenReturn('');
          when(() => processResult.exitCode).thenReturn(0);
          expect(
            await repository.isFFmpegEnvDetected(),
            isTrue,
          );
        });
      });
    });

    group('writeFFmpegContact', () {
      test('throws exception when file.create throws', () async {
        final File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenReturn(file);
        when(() => file.create(recursive: true)).thenThrow(Exception());
        expect(
          () async => await repository.writeFFmpegContact(texts: []),
          throwsException,
        );
        verify(() => file.create(recursive: true)).called(1);
        final caputred = verify(() => fileSystem.file(captureAny())).captured;
        expect(caputred, ['video.ffconcat']);
      });

      test('throws exception when file.writeAsString throws', () async {
        final File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenReturn(file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsString(captureAny())).thenThrow(Exception());
        await expectLater(
          repository.writeFFmpegContact(
            texts: [
              TimeText(
                text: 'SPECIAL_TITLE',
                startTimestamp: DateTime.now(),
                endTimeStamp: DateTime.now().add(const Duration(seconds: 2)),
              )
            ],
            directory: 'any',
          ),
          throwsException,
        );
        verify(() => file.create(recursive: true)).called(1);
        final caputred = verify(() => fileSystem.file(captureAny())).captured;
        expect(caputred, [p.join('any', 'video.ffconcat')]);
        final subtitleCaptured =
            verify(() => file.writeAsString(captureAny())).captured;
        expect(subtitleCaptured.length, greaterThan(0));
        expect(
          subtitleCaptured.first,
          allOf([
            contains('file transparent.png'),
            contains('frame_0'),
            contains('duration 2'),
          ]),
        );
      });

      test('returns normally', () async {
        final File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenReturn(file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        expect(
          () async => await repository.writeFFmpegContact(
            texts: [
              TimeText(
                text: 'SPECIAL_TITLE',
                startTimestamp: DateTime.now(),
                endTimeStamp: DateTime.now().add(const Duration(seconds: 2)),
              )
            ],
            directory: 'any',
          ),
          returnsNormally,
        );
      });
    });

    group('generateVideo', () {
      test('throws exception when exitCode != 0', () async {
        final processResult = MockProcessResult();
        const directory = 'dir';
        when(
          () => processManager.run(
            captureAny(),
            runInShell: true,
            workingDirectory: captureAny(named: 'workingDirectory'),
          ),
        ).thenAnswer((_) async => processResult);
        when(() => processResult.stderr).thenReturn('');
        when(() => processResult.stdout).thenReturn('');
        when(() => processResult.exitCode).thenReturn(-1);
        await expectLater(
          () async => await repository.generateVideo(directory: directory),
          throwsException,
        );

        final caputres = verify(
          () => processManager.run(
            captureAny(),
            runInShell: true,
            workingDirectory: captureAny(named: 'workingDirectory'),
          ),
        ).captured;
        expect(
          caputres.first,
          [
            'ffmpeg',
            '-y',
            '-i',
            'video.ffconcat',
            '-crf',
            '25',
            '-vf',
            'fps=60',
            '-c:v',
            'libx264',
            '-profile:v',
            'main',
            '-pix_fmt',
            'yuv420p',
            '-level:v',
            '4.2',
            'out.mp4'
          ],
        );
        expect(caputres.last, directory);
      });

      test('returnsNormally', () async {
        final processResult = MockProcessResult();
        const directory = 'dir';
        when(
          () => processManager.run(
            captureAny(),
            runInShell: true,
            workingDirectory: captureAny(named: 'workingDirectory'),
          ),
        ).thenAnswer((_) async => processResult);
        when(() => processResult.stderr).thenReturn('');
        when(() => processResult.stdout).thenReturn('');
        when(() => processResult.exitCode).thenReturn(0);
        expect(
          () async => await repository.generateVideo(directory: directory),
          returnsNormally,
        );
      });
    });
  });
}
