import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wand/utilities/font_manager.dart';

import '../_helper/helper_test.dart';

void main() {
  const String fontPath = 'test_resources/fonts/GenSenMaruGothicTW-Bold.ttf';
  late FontManager manager;
  setUp(() {
    TestHelper.setUpDirectory();
    manager = FontManager();
  });

  tearDown(() {});

  test('Font should be loaded properly', () async {
    const familyName = 'NEW_FONT';
    await manager.addFont(familyName, fontPath);
    expect(manager.contains(familyName), true);
  });
}
