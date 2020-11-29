import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wand/components/project/attribute_form_field.dart';

void main() {
  testWidgets('limited to the length of 4', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Center(
            child: AttributeFormField(
              type: AttributeFormFieldType.text,
            ),
          ),
        ),
      ),
    );
    final Finder attributeFormFieldFinder = find.byType(AttributeFormField);
    expect(attributeFormFieldFinder, findsOneWidget);

    await tester.enterText(find.byType(AttributeFormField), '01234');
    await tester.pump();

    expect(find.text('0123'), findsOneWidget);
  });

  testWidgets('controller should work as text form', (tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Center(
            child: AttributeFormField(
              type: AttributeFormFieldType.text,
              controller: controller,
            ),
          ),
        ),
      ),
    );
    final Finder attributeFormFieldFinder = find.byType(AttributeFormField);
    expect(attributeFormFieldFinder, findsOneWidget);

    await tester.enterText(find.byType(AttributeFormField), '01234');
    await tester.pump();

    expect(controller.text, '0123');
  });

  testWidgets('initialValue should set at first render', (tester) async {
    const INITIAL_VALUE = 'VALUE';
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Center(
            child: AttributeFormField(
              initialValue: INITIAL_VALUE,
              type: AttributeFormFieldType.text,
            ),
          ),
        ),
      ),
    );

    expect(find.text(INITIAL_VALUE), findsOneWidget);
  });

  
  testWidgets('Allow only positive number', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Center(
            child: AttributeFormField(
              type: AttributeFormFieldType.digit,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(AttributeFormField), 'This_will^&not-_123');
    await tester.pump();

    expect(find.text('123'), findsOneWidget);
  });

  testWidgets('Allow all integer values', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Center(
            child: AttributeFormField(
              type: AttributeFormFieldType.integer,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(AttributeFormField), '-1234');
    await tester.pump();

    expect(find.text('-123'), findsOneWidget);
  });

  testWidgets('Allow all text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Center(
            child: AttributeFormField(
              type: AttributeFormFieldType.text,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(AttributeFormField), '-!@!a');
    await tester.pump();

    expect(find.text('-!@!a'), findsNothing);
    expect(find.text('-!@!'), findsOneWidget);
  });
}