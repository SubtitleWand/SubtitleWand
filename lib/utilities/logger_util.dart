import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum LoggerLevel {
  Test,
  Debug,
  Production,
}
class LoggerUtil {
  File _jornalFile;
  static LoggerUtil _logger;
  final String _jornal = "journal.log";

  LoggerUtil._() {
    _jornalFile = File(_jornal);
  }

  LoggerLevel level = LoggerLevel.Test;

  Future<void> configure({
    LoggerLevel level = LoggerLevel.Test
  }) async {
    this.level = level;
    // if(level != LoggerLevel.Test)
    //   _jornalFile.writeAsStringSync("");
    if(Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      _jornalFile = File(p.join(appDocDir.path, _jornal));
    }
  }

  void clear() {
    if(level != LoggerLevel.Test) _jornalFile.writeAsStringSync("");
  }

  Future<void> log(String word, {bool isWriteToJournal = false}) async {
    if(level != LoggerLevel.Production) print("$word");
    if(level == LoggerLevel.Test) return;
    if(isWriteToJournal) await _jornalFile.writeAsString("[Debug]" + DateTime.now().toIso8601String() + "|" + word, mode: FileMode.writeOnlyAppend);
  }

  Future<void> logError(String word, {bool isWriteToJournal = false}) async {
    if(level != LoggerLevel.Production) print("$word");
    if(level == LoggerLevel.Test) return;
    if(isWriteToJournal) await _jornalFile.writeAsString("[Error]" + DateTime.now().toIso8601String() + "|" + word, mode: FileMode.writeOnlyAppend);
  }

  factory LoggerUtil.getInstance() {
    if(_logger == null) _logger = LoggerUtil._();
    return _logger;
  }
}