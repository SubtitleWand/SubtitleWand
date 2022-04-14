import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_painter/subtitle_painter.dart';
import 'package:subtitle_wand/widgets/attribute.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/font_picker_cubit.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_attribute_bloc.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_picker_cubit.dart';
import 'package:subtitle_wand/widgets/project/attribute_form_field.dart';

class SubtitleAttributePanel extends StatefulWidget {
  const SubtitleAttributePanel({
    Key? key,
  }) : super(key: key);

  @override
  State<SubtitleAttributePanel> createState() => _SubtitleAttributePanelState();
}

enum SubtitleTextType { plain, srt }

class _SubtitleAttributePanelState extends State<SubtitleAttributePanel> {
  // Properties
  // Properties - padding
  late TextEditingController _paddingLeftTextCon;
  late TextEditingController _paddingRightTextCon;
  late TextEditingController _paddingTopTextCon;
  late TextEditingController _paddingBottomTextCon;
  // Properties - font
  late TextEditingController _fontSizeTextCon;
  late ValueNotifier<Color?> _fontColor;
  // Properties - border
  late TextEditingController _borderWidthTextCon;
  late ValueNotifier<Color?> _borderColor;
  // Properties - shadow
  late TextEditingController _offsetXTextCon;
  late TextEditingController _offsetYTextCon;
  // late TextEditingController _spreadTextCon;
  late TextEditingController _blurTextCon;
  late ValueNotifier<Color?> _shadowColor;
  // Properties - Aligment
  late ValueNotifier<SubtitleVerticalAlignment> _verticalAlignment;
  late ValueNotifier<SubtitleHorizontalAlignment> _horizontalAlignment;
  // Properties - Canvas
  late TextEditingController _canvasResolutionXTextCon;
  late TextEditingController _canvasResolutionYTextCon;
  late ValueNotifier<Color?> _canvasColor;
  // Properties - Text
  late TextEditingController _subtilteTextController;
  late ValueNotifier<int> _subtitleSrtLines;

  late ValueNotifier<SubtitleTextType> _subtitleTextType;

  late final SubtitleAttributeBloc _subtitleAttributeBloc;

  @override
  void initState() {
    _subtitleAttributeBloc = BlocProvider.of<SubtitleAttributeBloc>(context);
    _paddingLeftTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyPaddingLeft.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyPaddingLeftChanged(
            propertyPaddingLeft: int.tryParse(_paddingLeftTextCon.text) ?? 0,
          ),
        );
      });
    _paddingRightTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyPaddingRight.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyPaddingRightChanged(
            propertyPaddingRight: int.tryParse(_paddingRightTextCon.text) ?? 0,
          ),
        );
      });
    _paddingTopTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyPaddingTop.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyPaddingTopChanged(
            propertyPaddingTop: int.tryParse(_paddingTopTextCon.text) ?? 0,
          ),
        );
      });
    _paddingBottomTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyPaddingBottom.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyPaddingBottomChanged(
            propertyPaddingBottom:
                int.tryParse(_paddingBottomTextCon.text) ?? 0,
          ),
        );
      });
    _fontSizeTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyFontSize.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyFontSizeChanged(
            propertyFontSize: int.tryParse(_fontSizeTextCon.text) ?? 0,
          ),
        );
      });
    _fontColor = ValueNotifier(_subtitleAttributeBloc.state.propertyFontColor)
      ..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyFontColorChanged(
            propertyFontColor: _fontColor.value ?? Colors.black,
          ),
        );
      });
    _borderWidthTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyBorderWidth.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyBorderWidthChanged(
            propertyBorderWidth: int.tryParse(_borderWidthTextCon.text) ?? 0,
          ),
        );
      });
    _borderColor =
        ValueNotifier(_subtitleAttributeBloc.state.propertyBorderColor)
          ..addListener(() {
            _subtitleAttributeBloc.add(
              SubtitlePropertyBorderColorChanged(
                propertyBorderColor: _borderColor.value ?? Colors.black,
              ),
            );
          });
    _offsetXTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyShadowX.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyShadowXChanged(
            propertyShadowX: int.tryParse(_offsetXTextCon.text) ?? 0,
          ),
        );
      });
    _offsetYTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyShadowY.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyShadowYChanged(
            propertyShadowY: int.tryParse(_offsetYTextCon.text) ?? 0,
          ),
        );
      });
    _blurTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyShadowBlur.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyShadowBlurChanged(
            propertyShadowBlur: int.tryParse(_blurTextCon.text) ?? 0,
          ),
        );
      });
    _shadowColor =
        ValueNotifier(_subtitleAttributeBloc.state.propertyShadowColor)
          ..addListener(() {
            _subtitleAttributeBloc.add(
              SubtitlePropertyShadowColorChanged(
                propertyShadowColor: _shadowColor.value ?? Colors.black,
              ),
            );
          });
    _verticalAlignment =
        ValueNotifier(_subtitleAttributeBloc.state.verticalAlignment)
          ..addListener(() {
            _subtitleAttributeBloc.add(
              SubtitleVerticalAlignmentChanged(
                verticalAlignment: _verticalAlignment.value,
              ),
            );
          });
    _horizontalAlignment =
        ValueNotifier(_subtitleAttributeBloc.state.horizontalAlignment)
          ..addListener(() {
            _subtitleAttributeBloc.add(
              SubtitleHorizontalAlignmentChanged(
                horizontalAlignment: _horizontalAlignment.value,
              ),
            );
          });
    _canvasResolutionXTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyCanvasResolutionX.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyCanvasResolutionXChanged(
            propertyCanvasResolutionX:
                int.tryParse(_canvasResolutionXTextCon.text) ?? 0,
          ),
        );
      });
    _canvasResolutionYTextCon = TextEditingController(
      text: _subtitleAttributeBloc.state.propertyCanvasResolutionY.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyCanvasResolutionYChanged(
            propertyCanvasResolutionY:
                int.tryParse(_canvasResolutionYTextCon.text) ?? 0,
          ),
        );
      });
    _canvasColor = ValueNotifier(
      _subtitleAttributeBloc.state.propertyCanvasBackgroundColor,
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertyCanvasBackgroundColorChanged(
            propertyCanvasBackgroundColor: _canvasColor.value ?? Colors.black,
          ),
        );
      });
    _subtilteTextController = TextEditingController(
      text: _subtitleAttributeBloc.state.propertySrtPlain.toString(),
    )..addListener(() {
        _subtitleAttributeBloc.add(
          SubtitlePropertySrtPlainChanged(
            propertySrtPlain: _subtilteTextController.text,
          ),
        );
      });
    _subtitleSrtLines =
        ValueNotifier(_subtitleAttributeBloc.state.propertySrtDatas.length);
    _subtitleTextType = ValueNotifier(SubtitleTextType.plain);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: ColorPalette.primaryColor,
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: ColorPalette.fontColor..withOpacity(0.8),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: ColorPalette.fontColor),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            Text(
              'Properites:',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 8,
            ),
            AttributePanel(
              title: 'Padding',
              children: [
                TextAttribute(
                  title: 'Left',
                  controller: _paddingLeftTextCon,
                ),
                const SizedBox(
                  height: 4,
                ),
                TextAttribute(
                  title: 'Right',
                  controller: _paddingRightTextCon,
                ),
                const SizedBox(
                  height: 4,
                ),
                TextAttribute(
                  title: 'Top',
                  controller: _paddingTopTextCon,
                ),
                const SizedBox(
                  height: 4,
                ),
                TextAttribute(
                  title: 'Bottom',
                  controller: _paddingBottomTextCon,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            AttributePanel(
              title: 'Font',
              children: [
                TextAttribute(
                  title: 'Size',
                  controller: _fontSizeTextCon,
                ),
                const SizedBox(
                  height: 8,
                ),
                ValueListenableBuilder(
                  valueListenable: _fontColor,
                  builder: (context, Color? color, child) => ColorAttribute(
                    title: 'Color',
                    onSelected: (color) => _fontColor.value = color,
                    color: color,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ButtonAttribute(
                  title: 'TTF',
                  childWidth: null,
                  buttonName: 'Choose a file',
                  onPressed: () async {
                    final picked = await context.read<FontPickerCubit>().pick();
                    _subtitleAttributeBloc.add(
                      SubtitlePropertyFontFamilyChanged(
                        propertyFontFamily: picked,
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            AttributePanel(
              title: 'Border',
              children: [
                TextAttribute(
                  title: 'Width',
                  controller: _borderWidthTextCon,
                ),
                const SizedBox(
                  height: 12,
                ),
                ValueListenableBuilder(
                  valueListenable: _borderColor,
                  builder:
                      (BuildContext context, Color? color, Widget? child) =>
                          ColorAttribute(
                    title: 'Color',
                    onSelected: (color) => _borderColor.value = color,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            AttributePanel(
              title: 'Shadow',
              children: [
                TextAttribute(
                  title: 'OffsetX',
                  titleWidth: 64,
                  type: AttributeFormFieldType.integer,
                  controller: _offsetXTextCon,
                ),
                const SizedBox(
                  height: 4,
                ),
                TextAttribute(
                  title: 'OffsetY',
                  titleWidth: 64,
                  type: AttributeFormFieldType.integer,
                  controller: _offsetYTextCon,
                ),
                const SizedBox(
                  height: 4,
                ),
                TextAttribute(
                  title: 'Blur',
                  titleWidth: 64,
                  controller: _blurTextCon,
                ),
                const SizedBox(
                  height: 4,
                ),
                ValueListenableBuilder(
                  valueListenable: _shadowColor,
                  builder:
                      (BuildContext context, Color? color, Widget? child) =>
                          ColorAttribute(
                    title: 'Color',
                    onSelected: (color) => _shadowColor.value = color,
                    color: color,
                    titleWidth: 64,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            AttributePanel(
              title: 'Alignment',
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Horizontal Alignment'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ValueListenableBuilder(
                    valueListenable: _horizontalAlignment,
                    builder: (
                      BuildContext context,
                      SubtitleHorizontalAlignment value,
                      Widget? child,
                    ) =>
                        SelectorAttribute(
                      nameToValues: Map.fromEntries(
                        SubtitleHorizontalAlignment.values
                            .map((e) => MapEntry(e.name, e)),
                      ),
                      selected: value,
                      onSelect: (SubtitleHorizontalAlignment selected) {
                        _horizontalAlignment.value = selected;
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Vertical Alignment'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ValueListenableBuilder(
                    valueListenable: _verticalAlignment,
                    builder: (
                      BuildContext context,
                      SubtitleVerticalAlignment value,
                      Widget? child,
                    ) =>
                        SelectorAttribute(
                      nameToValues: Map.fromEntries(
                        SubtitleVerticalAlignment.values
                            .map((e) => MapEntry(e.name, e)),
                      ),
                      selected: value,
                      onSelect: (SubtitleVerticalAlignment selected) {
                        _verticalAlignment.value = selected;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            AttributePanel(
              title: 'Canvas',
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Resolution'),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TextAttribute(
                    title: 'X',
                    controller: _canvasResolutionXTextCon,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TextAttribute(
                    title: 'Y',
                    controller: _canvasResolutionYTextCon,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Background'),
                ),
                const SizedBox(
                  height: 8,
                ),
                ValueListenableBuilder(
                  valueListenable: _canvasColor,
                  builder: (context, Color? color, child) => Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ColorAttribute(
                      title: 'Color',
                      onSelected: (color) => _canvasColor.value = color,
                      color: color,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ValueListenableBuilder(
              valueListenable: _subtitleTextType,
              builder: (context, type, child) {
                return AttributePanel(
                  title: 'Text',
                  children: [
                    CupertinoSegmentedControl<SubtitleTextType>(
                      onValueChanged: (v) async {
                        if (v == SubtitleTextType.srt) {
                          final picked =
                              await context.read<SubtitlePickerCubit>().pick();
                          _subtitleSrtLines.value = picked.length;
                          _subtitleAttributeBloc.add(
                            SubtitlePropertySrtDatasChanged(
                              propertySrtDatas: picked,
                            ),
                          );
                        } else {
                          _subtilteTextController.text = '';
                        }
                        _subtitleTextType.value = v;
                      },
                      groupValue: _subtitleTextType.value,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: Map.fromEntries(
                        SubtitleTextType.values.map(
                          (v) => MapEntry<SubtitleTextType, Widget>(
                            v,
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(v.name),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _subtitleTextType.value == SubtitleTextType.plain
                        ? Container(
                            constraints: const BoxConstraints(
                              minHeight: 120,
                              maxHeight: 480,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration:
                                BoxDecoration(color: ColorPalette.fontColor),
                            child: Scrollbar(
                              child: TextFormField(
                                controller: _subtilteTextController,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration.collapsed(
                                  hintText: null,
                                ),
                                style:
                                    TextStyle(color: ColorPalette.primaryColor),
                                maxLines: null,
                              ),
                            ),
                          )
                        : ValueListenableBuilder(
                            valueListenable: _subtitleSrtLines,
                            builder: (context, int count, child) =>
                                TextAttribute(
                              title: 'SRT Lines',
                              initValue: count.toString(),
                              readOnly: true,
                            ),
                          )
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
