@Skip('Helper method.')
import 'dart:io';

// @Tags(const ['helper']) // not supported yet
// Tag can be used to exclude test with --exclude-tags, or --tag to include,
// ex. --tags "(chrome || firefox) && !slow"

import 'package:flutter_test/flutter_test.dart';

import 'package:path/path.dart' show join;

class TestHelper {
  // setup directory to end with \test, to prevent test from affecting actual datas.
  static void setUpDirectory() {
    Directory.current = join(
      Directory.current.path,
      Directory.current.path.endsWith('test') ? '' : 'test',
    );
  }
}

void main() {

  // flutter test => D:\Project\McDedicatedServer\mc-dedicated-server-go\test
  // flutter test .\test\_helper\helper_test.dart => D:\Project\McDedicatedServer\mc-dedicated-server-go
  test("Test Directory", () {
    // expect(Directory.current.path, r"D:\Project\McDedicatedServer\mc-dedicated-server-go\test");
    TestHelper.setUpDirectory();
    expect(Directory.current.path.endsWith("test"), true);
  });
}