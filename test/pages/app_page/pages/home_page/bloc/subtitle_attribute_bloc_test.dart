import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_attribute_bloc.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_painter/subtitle_painter.dart';
import 'package:wand_api/wand_api.dart';

void main() {
  group('SubtitleAttributeBloc', () {
    test('initial state is correct', () {
      expect(SubtitleAttributeBloc().state, const SubtitleAttributeState());
    });

    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyPaddingLeftChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyPaddingLeftChanged(propertyPaddingLeft: 87)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyPaddingLeft: 87)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyPaddingRightChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc
          .add(SubtitlePropertyPaddingRightChanged(propertyPaddingRight: 78)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyPaddingRight: 78)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyPaddingTopChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyPaddingTopChanged(propertyPaddingTop: 123)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyPaddingTop: 123)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyPaddingBottomChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertyPaddingBottomChanged(propertyPaddingBottom: 456),
      ),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyPaddingBottom: 456)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyFontSizeChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyFontSizeChanged(propertyFontSize: 16)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyFontSize: 16)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyFontColorChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertyFontColorChanged(propertyFontColor: Colors.green),
      ),
      expect: () => [
        const SubtitleAttributeState().copyWith(propertyFontColor: Colors.green)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyFontFamilyChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc
          .add(SubtitlePropertyFontFamilyChanged(propertyFontFamily: 'Godis')),
      expect: () => [
        const SubtitleAttributeState().copyWith(propertyFontFamily: 'Godis')
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits nothing when SubtitlePropertyFontFamilyChanged\'s value is null.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyFontFamilyChanged(propertyFontFamily: null)),
      expect: () => [],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits nothing when SubtitlePropertyFontFamilyChanged\'s value is empty.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyFontFamilyChanged(propertyFontFamily: '')),
      expect: () => [],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyBorderWidthChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyBorderWidthChanged(propertyBorderWidth: 40)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyBorderWidth: 40)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyBorderColorChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertyBorderColorChanged(
          propertyBorderColor: Colors.amber,
        ),
      ),
      expect: () => [
        const SubtitleAttributeState()
            .copyWith(propertyBorderColor: Colors.amber)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyShadowXChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyShadowXChanged(propertyShadowX: 2)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyShadowX: 2)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyShadowYChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyShadowYChanged(propertyShadowY: 4)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyShadowY: 4)],
    );
    // blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
    //   'emits state changed when SubtitlePropertyShadowSpreadChanged is added.',
    //   build: () => SubtitleAttributeBloc(),
    //   act: (bloc) => bloc.add(SubtitlePropertyShadowSpreadChanged(propertyShadowSpread: 6)),
    //   expect: () => [
    //   const SubtitleAttributeState().copyWith(propertyFontColor: Colors.green)
    // ],
    // );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyShadowBlurChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertyShadowBlurChanged(propertyShadowBlur: 16)),
      expect: () =>
          [const SubtitleAttributeState().copyWith(propertyShadowBlur: 16)],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyShadowColorChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertyShadowColorChanged(propertyShadowColor: Colors.cyan),
      ),
      expect: () => [
        const SubtitleAttributeState()
            .copyWith(propertyShadowColor: Colors.cyan)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitleVerticalAlignmentChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitleVerticalAlignmentChanged(
          verticalAlignment: SubtitleVerticalAlignment.bottom,
        ),
      ),
      expect: () => [
        const SubtitleAttributeState()
            .copyWith(verticalAlignment: SubtitleVerticalAlignment.bottom)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitleHorizontalAlignmentChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitleHorizontalAlignmentChanged(
          horizontalAlignment: SubtitleHorizontalAlignment.right,
        ),
      ),
      expect: () => [
        const SubtitleAttributeState()
            .copyWith(horizontalAlignment: SubtitleHorizontalAlignment.right)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyCanvasResolutionXChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertyCanvasResolutionXChanged(
          propertyCanvasResolutionX: 1280,
        ),
      ),
      expect: () => [
        const SubtitleAttributeState().copyWith(propertyCanvasResolutionX: 1280)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertyCanvasResolutionYChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertyCanvasResolutionYChanged(
          propertyCanvasResolutionY: 720,
        ),
      ),
      expect: () => [
        const SubtitleAttributeState().copyWith(propertyCanvasResolutionY: 720)
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertySrtPlainChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) =>
          bloc.add(SubtitlePropertySrtPlainChanged(propertySrtPlain: '123')),
      expect: () => [
        const SubtitleAttributeState().copyWith(propertySrtPlain: '123'),
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed and clear srt when SubtitlePropertySrtPlainChanged is added after SubtitlePropertySrtDatasChanged.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) {
        bloc.add(
          SubtitlePropertySrtDatasChanged(
            propertySrtDatas: [
              TimeText(
                text: '1',
                startTimestamp: DateTime.fromMillisecondsSinceEpoch(1000),
                endTimeStamp: DateTime.fromMillisecondsSinceEpoch(3000),
              )
            ],
          ),
        );
        bloc.add(SubtitlePropertySrtPlainChanged(propertySrtPlain: '123'));
      },
      expect: () => [
        const SubtitleAttributeState().copyWith(
          propertySrtDatas: [
            TimeText(
              text: '1',
              startTimestamp: DateTime.fromMillisecondsSinceEpoch(1000),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(3000),
            )
          ],
        ),
        const SubtitleAttributeState().copyWith(propertySrtPlain: '123'),
      ],
    );
    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertySrtDatasChanged is added.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) => bloc.add(
        SubtitlePropertySrtDatasChanged(
          propertySrtDatas: [
            TimeText(
              text: '1',
              startTimestamp: DateTime.fromMillisecondsSinceEpoch(1000),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(3000),
            )
          ],
        ),
      ),
      expect: () => [
        const SubtitleAttributeState().copyWith(
          propertySrtDatas: [
            TimeText(
              text: '1',
              startTimestamp: DateTime.fromMillisecondsSinceEpoch(1000),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(3000),
            )
          ],
        ),
      ],
    );

    blocTest<SubtitleAttributeBloc, SubtitleAttributeState>(
      'emits state changed when SubtitlePropertySrtDatasChanged is added after SubtitlePropertySrtPlainChanged.',
      build: () => SubtitleAttributeBloc(),
      act: (bloc) {
        bloc.add(SubtitlePropertySrtPlainChanged(propertySrtPlain: '123'));
        bloc.add(
          SubtitlePropertySrtDatasChanged(
            propertySrtDatas: [
              TimeText(
                text: '1',
                startTimestamp: DateTime.fromMillisecondsSinceEpoch(1000),
                endTimeStamp: DateTime.fromMillisecondsSinceEpoch(3000),
              )
            ],
          ),
        );
      },
      expect: () => [
        const SubtitleAttributeState().copyWith(propertySrtPlain: '123'),
        const SubtitleAttributeState().copyWith(
          propertySrtDatas: [
            TimeText(
              text: '1',
              startTimestamp: DateTime.fromMillisecondsSinceEpoch(1000),
              endTimeStamp: DateTime.fromMillisecondsSinceEpoch(3000),
            )
          ],
        ),
      ],
    );
  });
}
