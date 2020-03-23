import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wand/utilities/font_manager.dart';

import '../_helper/helper_test.dart';

void main() {
  const String FONT_PATH = "test_resources/fonts/GenSenMaruGothicTW-Bold.ttf";
  FontManager manager;
  setUp(() {
    TestHelper.setUpDirectory();
    manager = FontManager();
  });

  tearDown(() {
    manager = null;
  });

  test("Font should be loaded properly", () async {
    const FAMILY_NAME = "NEW_FONT";
    await manager.addFont(FAMILY_NAME, FONT_PATH);
    expect(manager.contains(FAMILY_NAME), true);
  });
}