import 'dart:io';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:wand_api/wand_api.dart';
import 'package:path/path.dart' as p;

class FFmpegRepository {
  final FileSystem _fileSystem;
  final ProcessManager _processManager;
  final Platform _platform;

  FFmpegRepository({
    FileSystem? fileSystem,
    ProcessManager? processManager,
    Platform? platform,
  })  : _fileSystem = fileSystem ?? const LocalFileSystem(),
        _processManager = processManager ?? const LocalProcessManager(),
        _platform = platform ?? const LocalPlatform();

  Future<bool> isFFmpegEnvDetected() async {
    ProcessResult detectFFmpegResult = await _processManager.run(
      [_platform.isWindows ? 'where' : 'which', 'ffmpeg'],
      runInShell: true,
    );
    try {
      transformProcessResult(detectFFmpegResult);
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<void> generateVideo({String? directory}) async {
    // ffmpeg -y -i video.ffconcat -crf 25 -vf fps=60 -c:v libx264 -profile:v main -pix_fmt yuv420p -level:v 4.2 out.mp4
    ProcessResult ffmpegResult = await _processManager.run(
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
      runInShell: true,
      workingDirectory: directory,
    );
    String? _ = transformProcessResult(ffmpegResult);
  }

  Future<void> writeFFmpegContact({
    required List<TimeText> texts,
    String? directory,
  }) async {
    File ffmpegFile =
        _fileSystem.file(p.join(directory ?? '', 'video.ffconcat'));
    await ffmpegFile.create(recursive: true);
    final results = _transformToContact(texts);
    await ffmpegFile.writeAsString(results);
  }

  String _transformToContact(List<TimeText> texts) {
    String result = 'ffconcat version 1.0\n';
    double different = 0.5;
    for (int i = 0; i < texts.length; i++) {
      final currentFrame = texts[i];
      final currentFrameStart = currentFrame.startTimestamp;
      final currentFrameEnd = currentFrame.endTimeStamp;
      if (i == 0) {
        result += 'file transparent.png\n';
        result += 'duration ${currentFrameStart.millisecond / 1000}\n';
      }
      result += 'file frame_$i.png\n';
      final hasNextFrame = i + 1 < texts.length;
      if (hasNextFrame) {
        final nextFrame = texts[i + 1];
        final nextFrameStart = nextFrame.startTimestamp;
        // final nextFrameEnd = nextFrame.endTimeStamp;
        final frameDistance =
            nextFrameStart.difference(currentFrameEnd).inMilliseconds / 1000.0;
        final glueable = frameDistance < different;
        if (glueable) {
          result +=
              'duration ${(nextFrameStart.difference(currentFrameStart).inMilliseconds) / 1000.0}\n';
        } else {
          result +=
              'duration ${(currentFrameEnd.difference(currentFrameStart).inMilliseconds) / 1000.0}\n';
          result += 'file transparent.png\n';
          result +=
              'duration ${(nextFrameStart.difference(currentFrameEnd).inMilliseconds) / 1000.0}\n';
        }
      } else {
        result +=
            'duration ${(currentFrameEnd.difference(currentFrameStart).inMilliseconds) / 1000.0}\n';
      }

      // Add final frame
      if (i == texts.length - 1) {
        // result +=
        //     'duration ${(texts[i].endTimeStamp.difference(texts[i].startTimestamp).inMilliseconds) / 1000.0}\n';
        result += 'file transparent.png\n';
        result += 'duration 4\n';
      }
    }
    return result;
  }
}
