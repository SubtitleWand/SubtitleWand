// Copyright (C) 2020 Tokenyet
// 
// This file is part of subtitle-wand.
// 
// subtitle-wand is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// subtitle-wand is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with subtitle-wand.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show describeEnum;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart' show LogicalKeyboardKey, PlatformException, RawKeyDownEvent, RawKeyUpEvent, RawKeyboard;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pedantic/pedantic.dart';
import 'package:subtitle_wand/components/project/attribute_form_field.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/_components/attribute.dart';
import 'package:subtitle_wand/pages/_components/subtitle_panel_controller.dart';
import 'package:subtitle_wand/pages/_components/subtitle_panel.dart';
import 'package:subtitle_wand/pages/home_bloc.dart' as MPB;
import 'package:subtitle_wand/utilities/logger_util.dart';
import 'package:subtitle_wand/utilities/process_util.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Bloc
  MPB.HomePageBloc _bloc;
  // Core tool
  SubtitlePainter _painter;

  // FrameControlWidget f1 f2 keybinding UX
  Color defaultKey = Colors.white54;
  Color focusKey = Colors.white;
  Color f2Color;
  Color f1Color;

  // FrameControlWidget minimal and expand
  bool isMinimizeFrameControl = false;
  // AnimationController _frameButtonController;

  // Properties
  // Properties - padding
  TextEditingController _paddingLeftTextCon;
  TextEditingController _paddingRightTextCon;
  TextEditingController _paddingTopTextCon;
  TextEditingController _paddingBottomTextCon;
  // Properties - font
  TextEditingController _fontSizeTextCon;
  // Properties - border
  TextEditingController _borderWidthTextCon;
  // Properties - shadow
  TextEditingController _offsetXTextCon;
  TextEditingController _offsetYTextCon;
  TextEditingController _spreadTextCon;
  TextEditingController _blurTextCon;
  // Properties - Aligment
  //ignore: unused_field
  // final SubtitleVerticalAlignment _verticleAlignment = SubtitleVerticalAlignment.Bottom;
  //ignore: unused_field
  // final SubtitleHorizontalAlignment _horizontalAlignment = SubtitleHorizontalAlignment.Center;
  // Properties - Canvas
  TextEditingController _canvasResolutionXTextCon;
  TextEditingController _canvasResolutionYTextCon;
  // Properties - Text
  TextEditingController _subtilteTextController;

  SubtitlePanelMoveController _subtitlePanelMoveController;
  SubtitlePanelScrollController _subtitlePanelScrollController;

  Widget frameControlButton(BuildContext context, {
    bool isMinimize,
    Color dynamicButtonColor,
    String title = 'Untitled',
    void Function() onTap,
    IconData iconData,
  }){
    TextStyle btnTextStyle = Theme.of(context).textTheme.subtitle2;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            //color: dynamicButtonColor,
            gradient: LinearGradient(
              stops: [0,0.15,0.85,1],
              colors: [
                ColorPalette.secondaryColor.withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.accentColor.withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.accentColor.withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.secondaryColor.withOpacity(dynamicButtonColor.alpha / 255),
              ]
            ),
            border: Border.all(color: ColorPalette.secondaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(minWidth: isMinimize ? 48 : 160, minHeight: 48),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: isMinimize ? [
              Icon(iconData, color: btnTextStyle.color,),
            ] :
            <Widget>[
              Icon(iconData, color: btnTextStyle.color,),
              SizedBox(height: 8,),
              Text('$title', textAlign: TextAlign.center, style: btnTextStyle, overflow: TextOverflow.ellipsis,),
            ],
          )
        ),
        onTap:onTap,
      )
    );
  }

  @override
  void initState() { 
    super.initState();
    _bloc = MPB.HomePageBloc();

    _subtitlePanelMoveController = SubtitlePanelMoveController(Offset.zero);
    _subtitlePanelScrollController = SubtitlePanelScrollController(0);
    _painter = SubtitlePainter();
    _painter.update(canvasBackgroundColor: _bloc.state.propertyCanvasBackgroundColor);

    f1Color = f2Color = defaultKey;
    RawKeyboard.instance.addListener((e){
      if(_bloc.state.status.isSubmissionInProgress) return;
      final bool isKeyDown = e is RawKeyDownEvent;
      final bool isKeyUp = e is RawKeyUpEvent;

      bool isF2 = e.data.logicalKey == LogicalKeyboardKey.f2;
      bool isF1 = e.data.logicalKey == LogicalKeyboardKey.f1;

      if(isKeyDown) {
        if(isF1) {
          f1Color = focusKey;
          _bloc.add(MPB.PreviousFrameEvent());
        }
        if(isF2) {
          f2Color = focusKey;
          _bloc.add(MPB.NextFrameEvent());
        }
        if(isF1 || isF2) setState(() {});
      }

      if(isKeyUp) {
        if(isF1) f1Color = defaultKey;
        if(isF2) f2Color = defaultKey;
        if(isF1 || isF2) setState(() {});
      }
    });

    // Properties
    _paddingLeftTextCon = TextEditingController(text: _bloc.state.propertyPaddingLeft.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingLeftEvent(int.tryParse(_paddingLeftTextCon.text) ?? 0));
    });
    _paddingRightTextCon = TextEditingController(text: _bloc.state.propertyPaddingRight.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingRightEvent(int.tryParse(_paddingRightTextCon.text) ?? 0));
    });
    _paddingTopTextCon = TextEditingController(text: _bloc.state.propertyPaddingTop.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingBottomEvent(int.tryParse(_paddingTopTextCon.text) ?? 0));
    });
    _paddingBottomTextCon = TextEditingController(text: _bloc.state.propertyPaddingBottom.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingBottomEvent(int.tryParse(_paddingBottomTextCon.text) ?? 0));
    });
    // Properties - font
    _fontSizeTextCon = TextEditingController(text: _bloc.state.propertyFontSize.toString())..addListener((){
      _bloc.add(MPB.PropertyFontSizeEvent(int.tryParse(_fontSizeTextCon.text) ?? 0));
    });
    // Properties - border
    _borderWidthTextCon = TextEditingController(text: _bloc.state.propertyBorderWidth.toString())..addListener((){
      _bloc.add(MPB.PropertyBorderSizeEvent(int.tryParse(_borderWidthTextCon.text) ?? 0));
    });
    // Properties - shadow
    _offsetXTextCon = TextEditingController(text: _bloc.state.propertyShadowX.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowOffsetXEvent(int.tryParse(_offsetXTextCon.text) ?? 0));
    });
    _offsetYTextCon = TextEditingController(text: _bloc.state.propertyShadowY.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowOffsetYEvent(int.tryParse(_offsetYTextCon.text) ?? 0));
    });
    _spreadTextCon = TextEditingController(text: _bloc.state.propertyShadowSpread.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowSpreadEvent(int.tryParse(_spreadTextCon.text) ?? 0));
    });
    _blurTextCon = TextEditingController(text: _bloc.state.propertyShadowBlur.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowBlurEvent(int.tryParse(_blurTextCon.text) ?? 0));
    });
    // Properties - Aligment
    // SubtitleVerticleAligmnet _verticleAlignment = SubtitleVerticleAligmnet.Bottom;
    // SubtitleHorizontalAligmnet _horizontalAlignment = SubtitleHorizontalAligmnet.Center;
    // Properties - Canvas
    _canvasResolutionXTextCon = TextEditingController(text: _bloc.state.propertyCanvasResolutionX.toString())..addListener((){
      _bloc.add(MPB.PropertyCanvasResolutionXEvent(int.tryParse(_canvasResolutionXTextCon.text) ?? 0));
    });
    _canvasResolutionYTextCon = TextEditingController(text: _bloc.state.propertyCanvasResolutionY.toString())..addListener((){
      _bloc.add(MPB.PropertyCanvasResolutionYEvent(int.tryParse(_canvasResolutionYTextCon.text) ?? 0));
    });
    // Properties - Text
    _subtilteTextController = TextEditingController(text: '')..addListener((){
      _bloc.add(MPB.PropertySubtitleTextEvent(_subtilteTextController.text ?? ''));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: ColorPalette.fontColor),
        child: Container(
          child: BlocListener<MPB.HomePageBloc, MPB.HomePageState>(
            cubit: _bloc,
            listener: (context, state) {
              if(state.status.isSubmissionSuccess && state.openDir.isNotEmpty) {
                final path = state.openDir;
                if(Platform.isWindows) {
                  final result = Process.runSync('explorer', [path], runInShell: true, workingDirectory: Directory.current.path);
                  if(!ProcessUtil.isEmpty(result.stderr)) LoggerUtil.getInstance().logError(result.stderr, isWriteToJournal: true);
                } else if(Platform.isLinux) {
                  final result = Process.runSync('nautilus', [path], runInShell: true, workingDirectory: Directory.current.path);
                  if(!ProcessUtil.isEmpty(result.stderr)) LoggerUtil.getInstance().logError(result.stderr, isWriteToJournal: true);
                } else if(Platform.isMacOS) {
                  final result = Process.runSync('open', [path], runInShell: true, workingDirectory: Directory.current.path);
                  if(!ProcessUtil.isEmpty(result.stderr)) LoggerUtil.getInstance().logError(result.stderr, isWriteToJournal: true);
                }
              }

              if(state.exception is MPB.NotDetectFFmpegException) {
                showDialog(
                  context: context,
                  child: Dialog(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(text: 'FFmpeg not detected! You should install from '),
                            TextSpan(
                              text: 'here', 
                              style: TextStyle(color: ColorPalette.secondaryColor, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = 'https://ffmpeg.org/download.html';
                                  if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceSafariVC: false,
                                    );
                                  }
                                }
                            ),
                            TextSpan(text: ', and check If ffmpeg is added in enviroment variable.'),
                          ]
                        ),
                      )
                    )
                  )
                );
              }

              _painter.update(
                shadows: [
                  BoxShadow( // bottomLeft
                    offset: Offset(state.propertyShadowX.toDouble(), state.propertyShadowY.toDouble()),
                    color: state.propertyShadowColor,
                    spreadRadius: state.propertyShadowSpread.toDouble(),
                    blurRadius: state.propertyShadowBlur.toDouble(),
                  ),
                ],
                padding: EdgeInsets.only(
                  left: state.propertyPaddingLeft.toDouble(),
                  right: state.propertyPaddingRight.toDouble(),
                  top: state.propertyPaddingTop.toDouble(),
                  bottom: state.propertyPaddingBottom.toDouble()
                ),
                canvasResolution: Size(state.propertyCanvasResolutionX.toDouble(), state.propertyCanvasResolutionY.toDouble()),
                borderPaint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = state.propertyBorderWidth.toDouble()
                  ..color = state.propertyBorderColor,
                subtitleHorizontalAlignment: state.horizontalAlignment,
                subtitleAlignment: state.verticalAlignment,
                canvasBackgroundColor: state.propertyCanvasBackgroundColor,
              );
              setState(() {});
            },
            child: BlocBuilder<MPB.HomePageBloc, MPB.HomePageState>(
              cubit: _bloc,
              builder: (context, state) {
                bool isSavingState = state.status.isSubmissionInProgress;
                return AbsorbPointer(
                  absorbing: isSavingState,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.grey, isSavingState ? BlendMode.saturation : BlendMode.dst),
                    child: Column(
                      children: <Widget>[
                        _header(state),
                        Divider(height: 1, thickness: 1, color: ColorPalette.primaryColor.withGreen(80),),
                        Expanded(
                          child: Row(
                            children: [
                              // SubtitleFrame Section
                              Expanded(
                                child: _canvasPanel(state)
                              ),
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: ColorPalette.primaryColor,
                              ),
                              // Properties Section
                              _attributePanel(state)
                            ]
                          ),
                        ),
                        Divider(height: 1, thickness: 1, color:  ColorPalette.secondaryColor),
                        _footer(state)
                      ],
                    )
                  )
                );
              },
            ),
          )
        ),
      )
    );
  }

  Widget _footer(MPB.HomePageState state) {
    bool isSavingState = state.status.isSubmissionInProgress;
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: ColorPalette.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Version: 0.1.0',),
          isSavingState ?
          Container(
            width: 160,
            child: BlocBuilder<MPB.HomePageBloc, MPB.HomePageState>(
              cubit: _bloc,
              builder: (context, lpState) {
                return LinearProgressIndicator(
                  backgroundColor: ColorPalette.secondaryColor,
                  valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.accentColor),
                  value: lpState.currentFrame / ((lpState.propertyText.texts.length - 1) <= 0 ? 1 : (lpState.propertyText.texts.length - 1)),
                );
              },
            )
          )
          :
          Container()
        ],
      ),
    );
  }

  Widget _header(MPB.HomePageState state) {
    return Container(
      color: ColorPalette.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Subtitle wand', style: Theme.of(context).textTheme.headline6,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton.icon(
                color: ColorPalette.secondaryColor,
                textColor: ColorPalette.fontColor,
                disabledColor: ColorPalette.accentColor,
                icon: Icon(Icons.save_alt),
                label: Text('Save Video'),
                onPressed: (state.propertyText.type == MPB.PropertyTextType.srt && state.propertyText.texts.isNotEmpty) ? () async {
                  _bloc.add(MPB.SaveVideoEvent(painter: _painter));
                } : null,
              ),
              SizedBox(width: 8,),
              FlatButton.icon(
                color: ColorPalette.secondaryColor,
                textColor: ColorPalette.fontColor,
                disabledColor: ColorPalette.accentColor,
                icon: Icon(Icons.save_alt),
                label: Text('Save Image'),
                onPressed: state.propertyText.texts.isNotEmpty ? () async {
                  _bloc.add(MPB.SaveImageEvent(painter: _painter));
                } : null,
              )
            ],
          )
        ]
      ),
    );
  }

  Widget _canvasPanel(MPB.HomePageState state) {
    return Container(
      color: Colors.green,
      child: ClipRect(
        child: Column(
          children: <Widget>[
            // Subtitle Panel
            Expanded(
              child: Container(
                color: Colors.black,
                width: double.maxFinite,
                height: double.maxFinite,
                child: Container(
                  color: Colors.black,
                  child: SubtitlePanel(
                    painter: _painter, 
                    pmoveController: _subtitlePanelMoveController,
                    pscrollController: _subtitlePanelScrollController,
                    canvasResolution: Size(state.propertyCanvasResolutionX.toDouble(), state.propertyCanvasResolutionY.toDouble()),
                    span: TextSpan(
                      text: '${state.propertyText.texts.isNotEmpty ? state.propertyText.texts[state.currentFrame].text : ''}',
                      style: TextStyle(
                        fontFamily: state.propertyFontFamily,
                        color: state.propertyFontColor,
                        fontSize: state.propertyFontSize.toDouble(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Frame Panel
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              decoration: BoxDecoration(
                color: ColorPalette.accentColor,
                borderRadius: BorderRadius.circular(4)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Tooltip(
                    message: 'Previous Frame(F1)',
                    child: IconButton( 
                      onPressed: () { _bloc.add(MPB.PreviousFrameEvent()); }, 
                      color: f1Color,
                      icon: Icon(
                        Icons.skip_previous_outlined,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Next Frame(F2)',
                    child: IconButton( 
                      onPressed: () { _bloc.add(MPB.NextFrameEvent()); }, 
                      color: f2Color,
                      icon: Icon(
                        Icons.skip_next_outlined,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Reset Position',
                    child: IconButton( 
                      onPressed: () { _subtitlePanelMoveController.value = Offset.zero; }, 
                      icon: Icon(Icons.control_camera_outlined),
                    ),
                  ),
                  Tooltip(
                    message: 'Reset Scale',
                    child: IconButton( 
                      onPressed: () { _subtitlePanelScrollController.value = 0; }, 
                      icon: Icon(Icons.aspect_ratio_outlined),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _attributePanel(MPB.HomePageState state) {
    return Container(
      width: 240,
      color: ColorPalette.primaryColor,
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: ColorPalette.fontColor, unselectedWidgetColor:  ColorPalette.fontColor..withOpacity(0.8)),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          children: <Widget>[
            SizedBox(height: 16,),
            Text('Properites:', style: Theme.of(context).textTheme.headline6,),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Padding',
              children: [
                TextAttribute(
                  title: 'Left',
                  controller: _paddingLeftTextCon,
                ),
                SizedBox(height: 4,),
                TextAttribute(
                  title: 'Right',
                  controller: _paddingRightTextCon,
                ),
                SizedBox(height: 4,),
                TextAttribute(
                  title: 'Top',
                  controller: _paddingTopTextCon,
                ),
                SizedBox(height: 4,),
                TextAttribute(
                  title: 'Bottom',
                  controller: _paddingBottomTextCon,
                ),
              ],
            ),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Font',
              children: [
                TextAttribute(
                  title: 'Size',
                  controller: _fontSizeTextCon,
                ),
                SizedBox(height: 8,),
                ColorAttribute(
                  title: 'Color',
                  onSelected: (color) => _bloc.add(MPB.PropertyFontColorEvent(color)),
                  color: state.propertyFontColor
                ),
                SizedBox(height: 12,),
                ButtonAttribute(
                  childWidth: null,
                  title: 'TTF',
                  buttonName: 'Choose a file',
                  onPressed: () async {
                    final fileResult = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['ttf']);
                    if(fileResult == null) return;
                    _bloc.add(MPB.PropertyFontTtfEvent(fileResult.path));
                  },
                )
              ],
            ),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Border',
              children: [
                TextAttribute(
                  title: 'Width',
                  controller: _borderWidthTextCon,
                ),
                SizedBox(height: 12,),
                ColorAttribute(
                  title: 'Color',
                  onSelected: (color) => _bloc.add(MPB.PropertyBorderColorEvent(color)),
                  color: state.propertyBorderColor,
                )
              ],
            ),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Shadow',
              children: [
                TextAttribute(
                  title: 'OffsetX',
                  titleWidth: 64,
                  type: AttributeFormFieldType.integer,
                  controller: _offsetXTextCon,
                ),
                SizedBox(height: 4,),
                TextAttribute(
                  title: 'OffsetY',
                  titleWidth: 64,
                  type: AttributeFormFieldType.integer,
                  controller: _offsetYTextCon,
                ),
                SizedBox(height: 4,),
                TextAttribute(
                  title: 'Blur',
                  titleWidth: 64,
                  controller: _blurTextCon,
                ),
                SizedBox(height: 4,),
                ColorAttribute(
                  title: 'Color',
                  onSelected: (color) => _bloc.add(MPB.PropertyShadowColorEvent(color)),
                  color: state.propertyShadowColor,
                  titleWidth: 64,
                )
              ],
            ),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Alignment',
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Horizontal Alignment'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SelectorAttribute(
                    selectionA: 'Left',
                    selectionB: 'Center',
                    selectionC: 'Right',
                    selected: describeEnum(state.horizontalAlignment),
                    onSelect: (selected) {
                      SubtitleHorizontalAlignment.values.forEach(
                        (alignment){
                          if(selected.toLowerCase() == describeEnum(alignment).toLowerCase()) {
                            _bloc.add(MPB.PropertyAlignmentHorizontalEvent(alignment));
                          }
                        }
                      );
                      return;
                    },
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Vertical Alignment'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SelectorAttribute(
                    selectionA: 'Top',
                    selectionB: 'Center',
                    selectionC: 'Bottom',
                    selected: describeEnum(state.verticalAlignment),
                    onSelect: (selected) {
                      SubtitleVerticalAlignment.values.forEach(
                        (alignment){
                          if(selected.toLowerCase() == describeEnum(alignment).toLowerCase()) {
                            _bloc.add(MPB.PropertyAlignmentVerticalEvent(alignment));
                          }
                        }
                      );
                      return;
                    },
                  )
                ),
              ],
            ),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Canvas',
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Resolution'),
                ),
                SizedBox(height: 8,),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextAttribute(
                    title: 'X',
                    controller: _canvasResolutionXTextCon
                  ),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextAttribute(
                    title: 'Y',
                    controller: _canvasResolutionYTextCon
                  ),
                ),
                SizedBox(height: 16,),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text('Background'),
                ),
                SizedBox(height: 8,),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: ColorAttribute(
                    title: 'Color',
                    onSelected: (color) => _bloc.add(MPB.PropertyCanvasColorEvent(color)),
                    color: state.propertyCanvasBackgroundColor
                  ),
                )
              ],
            ),
            SizedBox(height: 8,),
            AttributePanel(
              title: 'Text',
              children: [
                CupertinoSegmentedControl<MPB.PropertyTextType>(
                  onValueChanged: (v) async {
                    if(v == MPB.PropertyTextType.srt) {
                      try {
                        final fileResult = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['srt']);
                        if(fileResult == null) return;
                        _bloc.add(MPB.PropertySrtEvent(fileResult.path));
                      } on PlatformException catch (e) {
                        unawaited(LoggerUtil.getInstance().logError(e.toString(), isWriteToJournal: true));
                      } catch (ex) {
                        unawaited(LoggerUtil.getInstance().logError(ex, isWriteToJournal: true));
                      }
                    } else {
                      _bloc.add(MPB.PropertySubtitleTextEvent(''));
                    }
                  },
                  groupValue: state.propertyText.type,
                  children: {
                    MPB.PropertyTextType.plain: Padding(padding: EdgeInsets.all(4), child: Text('Plain'),),
                    MPB.PropertyTextType.srt: Padding(padding: EdgeInsets.all(4), child: Text('SRT'),),
                  },
                ),
                SizedBox(height: 16,),
                state.propertyText.type == MPB.PropertyTextType.plain ?
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 120,
                      maxHeight: 480,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorPalette.fontColor
                    ),
                    child: Scrollbar(
                      child: TextFormField(
                        controller: _subtilteTextController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration.collapsed(hintText: null),
                        style: TextStyle(color: ColorPalette.primaryColor),
                        maxLines: null,
                      )
                    )
                  )
                :
                  TextAttribute(
                    title: 'SRT Lines',
                    titleWidth: null,
                    initValue: '${state.propertyText.texts.length}',
                    readOnly: true,
                  )
              ],
            ),
            SizedBox(height: 16,),
          ],
        ),
      )
    );
  }
}