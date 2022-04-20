import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wand/widgets/project/color_picker_dialog.dart';

import '../../_helper/normalizer_test.dart';

void main() {
  // staturation: white to red, hue: color rotation, value: white to black(lighting)
  testWidgets('staturation(x) and value(y) test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: Center(
            child: ElevatedButton(
              onPressed: null,
              child: Text('Go'),
            ),
          ),
        ),
      ),
    );

    final BuildContext context = tester.element(find.text('Go'));
    Future<Color?> result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    RenderBox renderBox = tester.renderObject(find.byType(ColorPickerArea));
    const double startX = 0;
    const double startY = 0;
    final double width = renderBox.size.width;
    final double height = renderBox.size.height;
    await tester.tapAt(renderBox.localToGlobal(const Offset(startX, startY)));
    await tester.pump();
    await tester.tap(find.text('Select'));
    expect(await result, Colors.white);

    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    renderBox = tester.renderObject(find.byType(ColorPickerArea));
    await tester.tapAt(renderBox.localToGlobal(Offset(startX, height)));
    await tester.pump();
    await tester.tap(find.text('Select'));
    expect(await result, Colors.black);

    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    renderBox = tester.renderObject(find.byType(ColorPickerArea));
    await tester.tapAt(renderBox.localToGlobal(Offset(width - 0.2, startY)));
    await tester.pump();
    await tester.tap(find.text('Select'));
    expect(await result, const Color(0xffff0000));

    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    renderBox = tester.renderObject(find.byType(ColorPickerArea));
    await tester.tapAt(renderBox.localToGlobal(Offset(width, height)));
    await tester.pump();
    await tester.tap(find.text('Select'));
    expect(await result, Colors.black);
  });

  testWidgets('hue test', (tester) async {
    // f00 -> ff0 -> 0f0 -> 0ff -> 00f -> f0f -> f00
    // width / 7, red yellow green gb blue purple red
    const Color redColor = Color(0xffff0000);
    const Color yellowColor = Color(0xffffff00);
    const Color greenColor = Color(0xff00ff00);
    const Color greenBlueColor = Color(0xff00ffff);
    const Color blueColor = Color(0xff0000ff);
    const Color purpleColor = Color(0xffff00ff);

    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: Center(
            child: ElevatedButton(
              onPressed: null,
              child: Text('Go'),
            ),
          ),
        ),
      ),
    );

    final BuildContext context = tester.element(find.text('Go'));

    // Red
    Future<Color?> result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    RenderBox satuationValueBox =
        tester.renderObject(find.byType(ColorPickerArea));
    RenderBox renderBox =
        tester.renderObject(find.byType(ColorPickerSlider).first);
    const double paddingOffset =
        15; // left 15, right 15, (260 - 30) / 6 = 38.3333(span)
    //final double width = renderBox.size.width; // padding sym 7
    const double span = 38.333; // (width + 48) / 6;
    final double height = renderBox.size.height;
    // 9
    // print("$width, $height");
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    // await tester.tapAt(renderBox.localToGlobal(Offset(0, height / 2)));
    await tester.pump();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(
      await result ?? Colors.transparent,
      redColor,
    );

    // Yellow
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    satuationValueBox = tester.renderObject(find.byType(ColorPickerArea));
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).first);
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    await tester.pump();
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(0, height / 2)),
      const Offset(paddingOffset + span, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(
      await result ?? Colors.transparent,
      yellowColor,
    );

    // Green
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    satuationValueBox = tester.renderObject(find.byType(ColorPickerArea));
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).first);
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    await tester.pump();
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(0, height / 2)),
      const Offset(paddingOffset + span * 2, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(
      await result ?? Colors.transparent,
      greenColor,
    );
    // Green blue
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    satuationValueBox = tester.renderObject(find.byType(ColorPickerArea));
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).first);
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    await tester.pump();
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(0, height / 2)),
      const Offset(paddingOffset + span * 3, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(
      await result ?? Colors.transparent,
      greenBlueColor,
    );

    // Blue
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    satuationValueBox = tester.renderObject(find.byType(ColorPickerArea));
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).first);
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    await tester.pump();
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(0, height / 2)),
      const Offset(paddingOffset + span * 4, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(
      await result ?? Colors.transparent,
      blueColor,
    );

    // Purple
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    satuationValueBox = tester.renderObject(find.byType(ColorPickerArea));
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).first);
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    await tester.pump();
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(0, height / 2)),
      const Offset(paddingOffset + span * 5, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(
      await result ?? Colors.transparent,
      purpleColor,
    );

    // Red
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    satuationValueBox = tester.renderObject(find.byType(ColorPickerArea));
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).first);
    await tester.tapAt(
      satuationValueBox
          .localToGlobal(Offset(satuationValueBox.size.width - 0.2, 0)),
    );
    await tester.pump();
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(0, height / 2)),
      const Offset(paddingOffset + span * 6, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    TestNormalizer.nearEqualColor(await result ?? Colors.transparent, redColor);
  });

  testWidgets('transparency test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: Center(
            child: ElevatedButton(
              onPressed: null,
              child: Text('Go'),
            ),
          ),
        ),
      ),
    );

    final BuildContext context = tester.element(find.text('Go'));

    // transparency 0
    Future<Color?> result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    RenderBox renderBox =
        tester.renderObject(find.byType(ColorPickerSlider).last);
    const double paddingOffset =
        15; // left 15, right 15, (260 - 30) / 6 = 38.3333(span)
    const double span = 38.333; // (width + 48) / 6;
    final double height = renderBox.size.height;
    await tester.tap(find.text('Select'));
    expect((await result)?.alpha, 255);

    // transparency 1
    result = showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return const ColorPickerDialog();
      },
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Pick a color!'), findsOneWidget);
    renderBox = tester.renderObject(find.byType(ColorPickerSlider).last);
    await tester.dragFrom(
      renderBox.localToGlobal(Offset(paddingOffset + span * 6, height / 2)),
      const Offset(-(paddingOffset + span * 6), 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    expect((await result)?.alpha, 0);
  });
}
