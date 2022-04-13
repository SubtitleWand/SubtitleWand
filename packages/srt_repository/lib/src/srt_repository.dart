import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wand_api/wand_api.dart';

class SrtRepository {
  final FileSystem _fileSystem;
  final FilePicker _picker;

  SrtRepository({
    FileSystem? fileSystem,
    FilePicker? picker,
  })  : _fileSystem = fileSystem ?? const LocalFileSystem(),
        _picker = picker ?? FilePicker.platform;

  Future<List<TimeText>> pickSrt() async {
    FilePickerResult? result = await _picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt'],
    );
    if (result != null) {
      return getSrtDatas(filePath: result.files.single.path ?? 'unexpected');
    } else {
      // User canceled the picker
      return [];
    }
  }

  Future<List<TimeText>> getSrtDatas({required String filePath}) async {
    final List<TimeText> result = [];
    File file = _fileSystem.file(filePath);
    if (!await file.exists()) return result;
    final raw = await file.readAsString();
    final RegExp reg = RegExp(
      r'(?<order>\d+)\n(?<start>[\d:,]+)\s+-{2}\>\s+(?<end>[\d:,]+)\n(?<text>[\s\S]*?(?=\n{2}|$))',
      caseSensitive: false,
      multiLine: true,
    );
    final matches = reg.allMatches(raw.replaceAll('\r', ''));
    for (final match in matches) {
      final _ = int.parse(match.namedGroup('order') ?? '');
      final startTime = _transformToDate(match.namedGroup('start') ?? '');
      final endTime = _transformToDate(match.namedGroup('end') ?? '');
      final text = match.namedGroup('text') ?? '';

      result.add(
        TimeText(
          text: text,
          startTimestamp: startTime,
          endTimeStamp: endTime,
        ),
      );
    }
    return result;
  }

  DateTime _transformToDate(String text) {
    List<String> srtTimeRaw = text.split(',');
    List<int> srtTimeTimeRaw =
        srtTimeRaw[0].split(':').map((e) => int.parse(e)).toList();
    int srtTimeMillesRaw = int.parse(srtTimeRaw[1]);
    int srtTimestamp = (srtTimeTimeRaw[0] * 3600 +
                srtTimeTimeRaw[1] * 60 +
                srtTimeTimeRaw[2]) *
            1000 +
        srtTimeMillesRaw;
    return DateTime.fromMillisecondsSinceEpoch(srtTimestamp);
  }
}
