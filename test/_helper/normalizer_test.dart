import 'dart:ui';

import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';

class TestNormalizer {
  // setup directory to end with \test, to prevent test from affecting actual datas.
  static void nearEqualColor(Color actual, Color expected, {double offset = 20}) {
    // print('''
    // actual:${actual.red} vs expected: ${expected.red}
    // actual:${actual.green} vs expected: ${expected.green}
    // actual:${actual.blue} vs expected: ${expected.blue}
    // ''');
    expect(nearEqual(actual.red.toDouble(), expected.red.toDouble(), offset), isTrue);
    expect(nearEqual(actual.green.toDouble(), expected.green.toDouble(), offset), isTrue);
    expect(nearEqual(actual.blue.toDouble(), expected.blue.toDouble(), offset), isTrue);
  }
}

void main() { 
}

// void main() {

//   // flutter test => D:\Project\McDedicatedServer\mc-dedicated-server-go\test
//   // flutter test .\test\_helper\helper_test.dart => D:\Project\McDedicatedServer\mc-dedicated-server-go
//   test("Test Directory", () {
//     // expect(Directory.current.path, r"D:\Project\McDedicatedServer\mc-dedicated-server-go\test");
//     TestHelper.setUpDirectory();
//     expect(Directory.current.path.endsWith("test"), true);
//   });
// }