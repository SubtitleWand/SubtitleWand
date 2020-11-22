import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wand/utilities/logger_util.dart';

import '../_helper/helper_test.dart';

void main() {
  const String CONST_JOURNAL_FILENAME = 'journal.log';
  RegExp jornalFormat = RegExp(r'^\[(Debug|Error)\]\d{4}\-\d{2}\-\d{2}T\d{2}\:\d{2}\:\d{2}\.\d{6}\|.*$');

  group('Logger', () {
    File journalFile = File(CONST_JOURNAL_FILENAME);
    setUp(() async { // delete journal.log first before testing
      TestHelper.setUpDirectory();
      if(await journalFile.exists()) await journalFile.delete();
      await LoggerUtil.getInstance().configure(level: LoggerLevel.Debug);
    });

    tearDown(() async {
      if(await journalFile.exists()) await journalFile.delete();
      await LoggerUtil.getInstance().configure(level: LoggerLevel.Test);
    });

    test('Init should have no journal', () async {
      //expect(true, Logger.getInstance().log("123"));
      LoggerUtil.getInstance();
      expect(await File(CONST_JOURNAL_FILENAME).exists(), false);
    });

    test('without writeToJournal shouldn\'t write to journal', () async {
      await LoggerUtil.getInstance().log('Logger Test 123');
      expect(await File(CONST_JOURNAL_FILENAME).exists(), false);
    });

    test('with writeToJournal should write to journal', () async {
      await LoggerUtil.getInstance().log('Logger Test 123', isWriteToJournal: true);
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      // print(await File(CONST_JOURNAL_FILENAME).readAsString());
      expect(jornalFormat.hasMatch(await File(CONST_JOURNAL_FILENAME).readAsString()), true);
    });

    test('clear should clear the journal', () async {
      await LoggerUtil.getInstance().log('Logger Test 123', isWriteToJournal: true);
      expect(jornalFormat.hasMatch(await File(CONST_JOURNAL_FILENAME).readAsString()), true);
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      LoggerUtil.getInstance().clear();
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      expect(await File(CONST_JOURNAL_FILENAME).readAsString(), '');
    });

    test('configure to Debug should clear the journal', () async {
      await LoggerUtil.getInstance().log('Logger Test 123', isWriteToJournal: true);
      expect(jornalFormat.hasMatch(await File(CONST_JOURNAL_FILENAME).readAsString()), true);
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      await LoggerUtil.getInstance().configure();
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      // expect(await File(CONST_JOURNAL_FILENAME).readAsString(), "");
    });

    
    test('configure to Production should not clear the journal', () async {
      await LoggerUtil.getInstance().log('Logger Test 123', isWriteToJournal: true);
      expect(jornalFormat.hasMatch(await File(CONST_JOURNAL_FILENAME).readAsString()), true);
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      await LoggerUtil.getInstance().configure(level: LoggerLevel.Production);
      expect(await File(CONST_JOURNAL_FILENAME).exists(), true);
      expect(jornalFormat.hasMatch(await File(CONST_JOURNAL_FILENAME).readAsString()), true);
    });
  });

}
